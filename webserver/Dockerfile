FROM ubuntu:18.04

MAINTAINER mmattox@mattoxengineering.com

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
    apt-utils \
    curl \
    apache2 \
    openssl \
    nano \
    iputils-ping \
    locales \
    ca-certificates \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


##Configure Apache
ADD apache.conf /etc/apache2/sites-available/
RUN a2dissite 000-default
RUN a2ensite apache.conf
RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log

EXPOSE 80

WORKDIR /var/www/src

ADD public_html /var/www/src

COPY run.sh /bin/run.sh
CMD /bin/run.sh

