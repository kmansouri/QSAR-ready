FROM docker.io/ubuntu:18.04

ENV DOWNLOAD_URL https://download.knime.org/analytics-platform/linux/knime-latest41-linux.gtk.x86_64.tar.gz
ENV INSTALLATION_DIR /usr/local
ENV KNIME_DIR $INSTALLATION_DIR/knime
ENV IMAGE_NAME kamelmansouri/knime:4.1.2

# Install everything
# HACK: Install tzdata at the beginning to not trigger an interactive dialog later on
RUN apt-get update \
    && apt-get install -y software-properties-common curl \
    && apt-get install -y tzdata \
    && apt-add-repository -y ppa:webupd8team/java \
    && apt-get update \
    && echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
    && echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections \
    && apt-get install -y openjdk-8-jre libgtk2.0-0 libxtst6 \
    && apt-get install -y libwebkitgtk-3.0-0 \
    && apt-get install -y python python-dev python-pip \
    && apt-get install -y curl

 # Download KNIME
RUN curl -L "$DOWNLOAD_URL" | tar vxz -C $INSTALLATION_DIR \
    && mv $INSTALLATION_DIR/knime_* $INSTALLATION_DIR/knime

# Clean up
RUN apt-get --purge autoremove -y software-properties-common curl \
    && apt-get clean

# Install pandas and protobuf so KNIME can communicate with Python
RUN pip install pandas && pip install protobuf

RUN $KNIME_DIR/knime -application org.eclipse.equinox.p2.director \
-r "http://update.knime.com/community-contributions/trusted/4.1,http://update.knime.com/community-contributions/4.1,http://update.knime.com/analytics-platform/4.1,http://update.knime.com/store/4.1,http://update.knime.com/partner/4.1" \
-p2.arch x86_64 \
-profileProperties org.eclipse.update.install.features=true \
-i "org.knime.features.exttool.feature.group,org.knime.features.ext.chromium.feature.group,org.eclipse.equinox.p2.rcp.feature.feature.group,org.knime.features.xml.feature.group,org.knime.product.desktop.feature.group,org.eclipse.platform.feature.group,org.knime.features.database.feature.group,org.knime.features.js.core.feature.group,org.eclipse.rcp.feature.group,org.eclipse.draw2d.feature.group,de.nbi.cibi.feature.feature.group,org.knime.features.ext.poi.feature.group,org.knime.features.js.views.feature.group,org.knime.features.ext.jep.feature.group,com.knime.features.enterprise.client.feature.group,org.knime.features.rest.feature.group,org.knime.features.js.quickforms.feature.group,org.eclipse.ecf.filetransfer.feature.feature.group,org.knime.features.chem.types.feature.group,org.eclipse.emf.common.feature.group,org.knime.features.dbdrivers.feature.group,org.eclipse.ecf.filetransfer.httpclient4.ssl.feature.feature.group,org.knime.features.ext.svg.feature.group,org.eclipse.e4.rcp.feature.group,org.knime.features.personalproductivity.feature.group,org.knime.binary.jre.feature.group,org.knime.features.json.feature.group,org.eclipse.ecf.core.feature.feature.group,org.eclipse.ecf.filetransfer.httpclient4.feature.feature.group,org.eclipse.equinox.p2.core.feature.feature.group,org.rdkit.knime.feature.feature.group,com.vernalis.knime.feature.feature.group,org.eclipse.equinox.p2.user.ui.feature.group,org.eclipse.ecf.filetransfer.ssl.feature.feature.group,org.eclipse.emf.ecore.feature.group,org.eclipse.equinox.p2.extras.feature.feature.group,jp.co.infocom.cheminfo.marvin.feature.feature.group,org.knime.features.base.feature.group,org.eclipse.ecf.core.ssl.feature.feature.group,org.eclipse.help.feature.group,org.rdkit.knime.binaries.feature.feature.group,org.knime.product.desktop,org.eclipse.gef.feature.group,com.epam.indigo.knime.feature.feature.group,org.knime.features.ensembles.feature.group" \
-p KNIMEProfile \
-nosplash


# Add extra commands for an Ubuntu bash here

ENTRYPOINT $KNIME_DIR/knime
