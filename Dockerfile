# 2022 December
FROM debian:stable@sha256:880aa5f5ab441ee739268e9553ee01e151ccdc52aa1cd545303cfd3d436c74db

ENV DEBIAN_FRONTEND noninteractive
ENV PATH="${PATH}:/opt/cprocsp/bin/amd64/"

# Downloaded from https://www.cryptopro.ru/fns_experiment
ADD csp-fns-amd64_deb.tgz /cryptopro

# Downloaded from https://www.rutoken.ru/support/download/pkcs/#linux
COPY librtpkcs11ecp_2.6.1.0-1_amd64.deb /cryptopro

# Downloaded from https://restapi.moedelo.org/eds/crypto/plugin/api/v1/installer/download?os=linux&version=latest
COPY moedelo-plugin_*_amd64.deb /cryptopro

# Downloaded from install.kontur.ru
COPY kontur.plugin_amd64.deb /cryptopro

# Downloaded from https://ds-plugin.gosuslugi.ru/plugin/upload/Index.spr
COPY IFCPlugin-x86_64.deb /cryptopro

# Downloaded from https://www.rutoken.ru/support/download/get/rtPlugin-deb-x64.html
COPY libnpRutokenPlugin_*_amd64.deb /cryptopro

RUN apt-get update && \
    apt-get install -y whiptail libccid libpcsclite1 pcscd pcsc-tools opensc \
    libgtk2.0-0 libcanberra-gtk-module libcanberra-gtk3-0 libsm6 \
    firefox-esr && \
    cd /cryptopro/fns-amd64_deb && \
    dpkg -i /cryptopro/librtpkcs11ecp_*_amd64.deb && \
    sed -i s#install_gui#install# _FNS_INSTALLER.sh && \
    ./_FNS_INSTALLER.sh && \
    dpkg -i /cryptopro/fns-amd64_deb/cprocsp-pki-cades-64_*_amd64.deb && \
    dpkg -i /cryptopro/fns-amd64_deb/cprocsp-rdr-gui-gtk-64_*_amd64.deb && \
    dpkg -i /cryptopro/fns-amd64_deb/cprocsp-pki-plugin-64_*_amd64.deb && \
    dpkg -i /cryptopro/fns-amd64_deb/cprocsp-cptools-gtk-64_*_amd64.deb && \
    dpkg -i /cryptopro/fns-amd64_deb/cprocsp-rdr-pcsc-64_*_amd64.deb && \
    dpkg -i /cryptopro/fns-amd64_deb/cprocsp-rdr-rutoken-64_*_amd64.deb && \
    dpkg -i /cryptopro/fns-amd64_deb/cprocsp-rdr-cryptoki-64_*_amd64.deb && \
    dpkg -i /cryptopro/moedelo-plugin_*_amd64.deb && \
    dpkg -i /cryptopro/kontur.plugin_amd64.deb && \
    dpkg -i /cryptopro/IFCPlugin-x86_64.deb && \
    dpkg -i /cryptopro/libnpRutokenPlugin_*_amd64.deb

# Downloaded from https://www.cryptopro.ru/sites/default/files/products/cades/extensions/firefox_cryptopro_extension_latest.xpi
COPY firefox_cryptopro_extension_latest.xpi /usr/lib/firefox-esr/distribution/extensions/ru.cryptopro.nmcades@cryptopro.ru.xpi

# Downloaded from install.kontur.ru (firefox addon)
COPY kontur.toolbox@gmail.com.xpi /usr/lib/firefox-esr/distribution/extensions/kontur.toolbox@gmail.com.xpi

# Downloaded from https://ds-plugin.gosuslugi.ru/plugin/upload/Index.spr
COPY addon-1.2.8-fx.xpi /usr/lib/firefox-esr/distribution/extensions/pbafkdcnd@ngodfeigfdgiodgnmbgcfha.ru.xpi

# Downloaded from https://addons.mozilla.org/ru/firefox/addon/adapter-rutoken-plugin/
COPY rutokenplugin@rutoken.ru.xpi /usr/lib/firefox-esr/distribution/extensions/rutokenplugin@rutoken.ru.xpi

CMD ["bash"]
