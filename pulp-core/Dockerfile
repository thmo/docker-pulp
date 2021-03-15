FROM fedora:33 as build
ENV PYTHONUNBUFFERED 1

# Install build dependencies
RUN dnf install -y \
      curl \
      python3 python3-virtualenv python3-devel \
      createrepo_c-devel \
      cmake \
      make \
      gcc \
      git \
      libpq-devel \
      ninja-build \
      cairo-devel \
      libpq-devel \
      rpm-devel \
      file-devel \
      sqlite-devel \
      libxml2-devel \
      zlib-devel \
      expat-devel \
      libmodulemd-devel \
      gobject-introspection-devel \
      cairo-gobject-devel \
      zchunk-devel

# Create virtualenv
RUN virtualenv -p python3 /opt/pulp

# Ensure uptodate pip and wheel
RUN /opt/pulp/bin/pip install -U \
	pip setuptools wheel

# Install pulp and plugins
COPY requirements.txt /opt/pulp/pulp-requirements.txt
RUN /opt/pulp/bin/pip install -U -r /opt/pulp/pulp-requirements.txt

## Main image
FROM fedora:33
ENV PYTHONUNBUFFERED 1
ENV PATH /opt/pulp/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV DJANGO_SETTINGS_MODULE="pulpcore.app.settings" \
    PULP_DATABASES__default__ENGINE="django.db.backends.postgresql_psycopg2" \
    PULP_DATABASES__default__NAME="pulp" \
    PULP_DATABASES__default__USER="pulp"

COPY --from=build /opt/pulp /opt/pulp

# TODO: tini should be in newer Dockers already; do we need to install this?
# https://github.com/krallin/tini/#using-tini
# if not; consider a github scheduled action to check release version
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/local/bin/tini
RUN chmod +x /usr/local/bin/tini

RUN useradd --system -m -d /var/lib/pulp -s /sbin/nologin pulp

RUN dnf install -y curl \
      python3 \
      createrepo_c-libs \
      postgresql \
      libpq \
      sqlite \
      libxml2 \
      zlib \
      file-libs \
      libmodulemd \
      gobject-introspection \
      expat \
      zchunk-libs \
      compat-openssl10 \
    && dnf clean all

WORKDIR /var/lib/pulp
USER pulp
