FROM fedora:33 as build
ENV PYTHONUNBUFFERED 1

# https://pypi.org/project/pulpcore/#history
ENV PULP_VERSION 3.10.0

# NOTE: Extension versions must support pulpcore version!
# https://pypi.org/project/pulp-file/#history
ENV PULP_FILE_VERSION 1.5.0
# https://pypi.org/project/pulp-container/#history
ENV PULP_CONTAINER_VERSION 2.3.1
# https://pypi.org/project/pulp-rpm/#history
ENV PULP_RPM_VERSION 3.9.0

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

# Install pulp
RUN virtualenv -p python3 /opt/pulp

# Ensure uptodate pip and wheel
RUN /opt/pulp/bin/pip install -U \
	pip setuptools wheel

# Install plugins
RUN /opt/pulp/bin/pip install pulpcore==$PULP_VERSION pulp-file==$PULP_FILE_VERSION pulp-container==$PULP_CONTAINER_VERSION pulp-rpm==$PULP_RPM_VERSION pip gunicorn

## Main image
FROM fedora:33
ENV PYTHONUNBUFFERED 1
ENV PATH /opt/pulp/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV DJANGO_SETTINGS_MODULE="pulpcore.app.settings" \
    PULP_DATABASES__default__ENGINE="django.db.backends.postgresql_psycopg2" \
    PULP_DATABASES__default__NAME="pulp" \
    PULP_DATABASES__default__USER="pulp"

COPY --from=build /opt/pulp /opt/pulp

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
    && dnf clean all

WORKDIR /var/lib/pulp
USER pulp
