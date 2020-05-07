#!/bin/bash
# Version 4.0
# - Code is better written as 3.0
# - check if file exists

args=()
workflow=$1
declare -i multi_wrk=0
declare -i execute=1
n=$(find /QSARready/workflow -name "dockermeta.knime" |wc -l)

if [ "$workflow" = "--vars" ]; then
    echo "Workflow variables needed for executing the workflows:"
    echo "-----------------------------------------------------"
    while IFS=  read -r -d $'\0'; do
      # Cut off the "/QSARready/workflow/" part because the user does not have to specify it.
      if [ $n -gt 1 ]; then
        name="$(dirname ${REPLY#./workflow/})"
        echo "${name:18}"
      fi
      echo -e 'Name\tType\tDefault Value'
      cat "$REPLY" | tr ':' '\t'
      echo "========"
    done < <(find "/QSARready/workflow" -name dockermeta.knime -print0)
    execute=0
elif [ "$workflow" = "--info" ]; then
    if [ $n -gt 1 ]; then
        echo "Workflows:"
        echo "-----------------------------------------------------"
        while IFS=  read -r -d $'\0'; do
        name="$(dirname ${REPLY#./workflow/})"
        echo "${name:18}"
        done < <(find "/QSARready/workflow" -name dockermeta.knime -print0)
    fi
    echo "-----------------------------------------------------"
    echo "Installed features:"
    echo "-----------------------------------------------------"
    cat /QSARready/meta/features
    execute=0
elif [ "$workflow" = "--help" ]; then
    echo "Help:"
    echo "To run the image and mount a folder in the container:"
    if [ $n -gt 1 ]; then
        echo "docker run -v <local_folder>:<container_folder> <image_name> <workflow_path> <workflow_variable_name>=<value>"
        echo "Eg: docker run -v /User/MyUser/Documents/Data:/data myworkflowGroup mySubGroup/myworkflow input_file=test.csv"
        echo ""
        echo "To list contained workflows and installed features:"
        echo "docker run -rm <image_name> --info"
    elif [ $n == 1 ]; then
        echo "docker run -v <local_folder>:<container_folder> <image_name> <workflow_variable_name>=<value>"
        echo "Eg: docker run -v /User/MyUser/Documents/Data:/data myworkflowGroup input_file=test.csv"
        echo ""
        echo "To list installed features:"
        echo "docker run -rm <image_name> --info"
    fi
    echo ""
    echo "To list the workflows' variables:"
    echo "docker run -rm <image_name> --vars"
    
    execute=0
fi

#check for amount of workspace
if [ $n == 0 ]; then
 echo "No workflow found. Check if the workflow directory was correctly specified during the build."
elif [ $n == 1 ]; then
 wrk="${@:1}"
 workflow=""
 echo "One workflow found."
elif [ $n -gt 1 ]; then
 wrk="${@:2}"
 multi_wrk=1 
 echo "Multiple workflows found."
 # Check if file exists
 if [[ $execute == 1 && ! -f "/QSARready/workflow/$workflow/dockermeta.knime" ]]
 then
    >&2 echo "Workflow not found. Check the workflow name. Run the image with --info to see the contained workflows."
    n=0
 fi
fi

if [[ $execute == 1 && $n -gt 0 ]] ; then
    for var in $wrk
    do
	  # Extract the variable name
	  name=$(echo $var | awk -F '=' '{print $1}')
	  # Extract the type
	  value=$(echo $var | awk -F '=' '{print $2}')
	  # Get the type from the meta file checking if its a single or a multiple workflow
	  if [ $multi_wrk == 1 ] ; then
	   type=$(cat /QSARready/workflow/$workflow/dockermeta.knime | grep $name | awk -F ':' '{print $2}')
          else
	   type=$(cat /QSARready/workflow/dockermeta.knime | grep $name | awk -F ':' '{print $2}')	
	  fi
	  # Add argument to the array
	  args=("${args[@]}" "-workflow.variable=$name,\"$value\",$type")
	  #\\\"
    done
    # Call KNIME with the arguments
    WORKDIR="$(pwd)"
    $KNIME_DIR/knime -configuration $WORKDIR/configuration -data $WORKDIR -user $WORKDIR -nosplash -nosave -reset -application org.knime.product.KNIME_BATCH_APPLICATION \
      -workflowDir="/QSARready/workflow/$workflow" \
      "${args[@]}"
fi
