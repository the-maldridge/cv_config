#!/bin/sh

MKDOCS_SITE_PATH="/opt/var/mkdocs/{{ mkdocs_site_name }}"
MKDOCS_CLONE_URI="{{ mkdocs_source_url }}"
MKDOCS_SERVE_PATH="{{ mkdocs_site_path}}"

# Does the Mkdocs content path exist
if [ ! -d "$MKDOCS_SITE_PATH" ] ; then
    mkdir -p "$MKDOCS_SITE_PATH"
fi

# Jump into the content path
cd "$MKDOCS_SITE_PATH"

# If we have .git update, otherwise clone
if [ -d .git ] ; then
    git pull
else
    git clone "$MKDOCS_CLONE_URI" .
fi

# Build destdir if it doesn't exist
if [ ! -d "$MKDOCS_SERVE_PATH" ] ; then
    mkdir -p "$MKDOCS_SERVE_PATH"
fi

# Build the site
mkdocs build

# Deploy the site
rsync -a site/ "$MKDOCS_SERVE_PATH"

# Fix the system permissions
chmod -R og+rX "$MKDOCS_SERVE_PATH"
