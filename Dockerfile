FROM mysql:8.0
MAINTAINER shoichi1023 <so_1117@outlook.jp>
RUN apt-get update \
    && apt-get install -y mecab libmecab-dev mecab-ipadic-utf8 git make curl xz-utils file \
    && cd /usr/bin \
    && mv mecab-config /usr/local \
    && cd /usr/local \
    && sed -e 's#${prefix}/lib/x86_64-linux-gnu/mecab/dic#/var/lib/mecab/dic#' ./mecab-config > /usr/bin/mecab-config \
    && rm mecab-config \
    && cd /var/lib/mecab/dic \
    && git clone https://github.com/neologd/mecab-ipadic-neologd.git \
    && cd mecab-ipadic-neologd \
    && chmod 777 /usr/bin/mecab-config \
    && ./bin/install-mecab-ipadic-neologd -n -y \ 
    && cd /etc/ \
    && mv mecabrc /usr/local/ \
    && cd /usr/local \
    && sed -e 's#debian#mecab-ipadic-neologd#' ./mecabrc > /etc/mecabrc \
    && rm mecabrc \
    && cd /etc/mysql \
    && echo "character-set-server=utf8mb4" >> my.cnf \
    && echo "# mecab\nloose-mecab-rc-file=/etc/mecabrc\ninnodb_ft_min_token_size=1" >> my.cnf \
    && echo "[client]\ndefault-character-set=utf8mb4" >> my.cnf \
    && echo "INSTALL PLUGIN mecab SONAME 'libpluginmecab.so';" > /docker-entrypoint-initdb.d/1_install_mecab_plugin.sql \
    && apt-get install -y locales \
    && rm -rf /var/lib/apt/lists/* \
    && echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen ja_JP.UTF-8

ENV LC_ALL ja_JP.UTF-8


