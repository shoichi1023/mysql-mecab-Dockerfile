FROM mysql:8.0

RUN apt-get update \
    && apt-get install -y mecab libmecab-dev mecab-ipadic-utf8 git make curl xz-utils file \
    && cd /usr/bin \
    && mv mecab-config /usr/local \
    && cd /usr/local \
    && sed -e 's#${prefix}/lib/x86_64-linux-gnu/mecab/dic#/var/lib/mecab/dic' ./mecab-config > /usr/bin/mecab-config \
    && rm mecab-config \
    && cd /var/lib/mecab/dic \
    && git clone https://github.com/neologd/mecab-ipadic-neologd.git \
    && cd mecab-ipadic-neologd.git \
    && ./bin/install-mecab-ipadic-neologd -n \
    && cd /etc/ \
    && mv mecabrc /usr/local/ \
    && cd /usr/local \
    && sed -e 's#debian#mecab-ipadic-neologd' ./mecabrc > /etc/mecabrc \
    && rm mecab-rc \
    && cd /etc/mysql \
    && echo -e "default-charcter-set=utf8mb4" > my.cnf \
    && echo -e "# mecab\nloose-mecab-rc-file=/etc/mecabrc\ninnodb_ft_min_token_size=1" > my.cnf \
    && echo -e "[client]\ndefault-charcter-set=utf8mb4" > my.cnf \
    && apt-get install -y locales \
    && rm -rf /var/lib/apt/lists/* \
    && echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen ja_JP.UTF-8

ENV LC_ALL ja_JP.UTF-8


