# Makefile for this Jekyll blog
# Usage: make <target>

SHELL := /bin/bash
JEKYLL := bundle exec jekyll
BUILD_DIR := _site
PORT ?= 4000
HOST ?= 127.0.0.1
JEKYLL_ENV ?= development

.PHONY: help install build build-dev serve serve-drafts watch clean clean-deps rebuild open deploy

help:
	@echo "Usage: make <target>"
	@echo "Targets:"
	@echo "  install         Install Ruby gems (bundle install)"
	@echo "  build           Build site for production (JEKYLL_ENV=production)"
	@echo "  build-dev       Build site for development (JEKYLL_ENV=development)"
	@echo "  serve           Serve locally with livereload (default host $(HOST), port $(PORT))"
	@echo "  serve-drafts    Serve locally including drafts"
	@echo "  watch           Alias for serve (livereload)"
	@echo "  clean           Remove generated site ($(BUILD_DIR))"
	@echo "  clean-deps      Remove bundler cache and Gemfile.lock (use with caution)"
	@echo "  rebuild         clean + build"
	@echo "  open            Open the local site in the default browser"
	@echo "  deploy          Build site for production (same as build)"

install:
	@echo "Installing Ruby and Bundler if missing..."
	@if command -v bundle >/dev/null 2>&1; then \
	  echo "Bundler found."; \
	else \
	  echo "Bundler not found. Ensuring Ruby is installed..."; \
	  if ! command -v ruby >/dev/null 2>&1; then \
	    echo "Ruby not found. Attempting to install via package manager..."; \
	    if command -v apt-get >/dev/null 2>&1; then \
	      sudo apt-get update && sudo apt-get install -y build-essential ruby-full zlib1g-dev || exit 1; \
	    elif command -v yum >/dev/null 2>&1; then \
	      sudo yum install -y gcc make ruby-devel zlib-devel || exit 1; \
	    elif command -v apk >/dev/null 2>&1; then \
	      sudo apk add --no-cache build-base ruby ruby-dev zlib-dev || exit 1; \
	    else \
	      echo "No supported package manager found. Please install Ruby manually." >&2; exit 1; \
	    fi; \
	  fi; \
	  if command -v sudo >/dev/null 2>&1; then \
	    sudo gem install bundler || { echo 'gem install bundler failed' >&2; exit 1; }; \
	  else \
	    gem install --user-install bundler || { echo 'gem install bundler failed; try running with sudo' >&2; exit 1; }; \
	  fi; \
	fi; \
	# Ensure user gem bin is available in PATH for this subshell
	export PATH="$$(ruby -e 'print Gem.user_dir')/bin:$$PATH"; \
	# Remove vendored gems to avoid old Bundler (e.g., 1.17) being picked up
	rm -rf vendor/bundle; \
	# Strip BUNDLED WITH section from Gemfile.lock to prevent Bundler version switching
	if [ -f Gemfile.lock ] && grep -q '^BUNDLED WITH' Gemfile.lock; then \
	  awk 'BEGIN{skip=0} /^BUNDLED WITH$$/{skip=1; next} skip==1 {skip=0; next} {print}' Gemfile.lock > Gemfile.lock.tmp && mv Gemfile.lock.tmp Gemfile.lock; \
	  echo "Removed BUNDLED WITH section from Gemfile.lock"; \
	fi; \
	echo "Installing gems into vendor/bundle..."; \
	BUNDLE_DISABLE_VERSION_CHECK=1 BUNDLE_PATH=vendor/bundle BUNDLE_JOBS=4 BUNDLE_RETRY=3 bundle install || { echo "bundle install failed. If you intended to install system gems, run: sudo bundle install" >&2; exit 1; }

build:
	@echo "Building site for production..."
	JEKYLL_ENV=production $(JEKYLL) build

build-dev:
	@echo "Building site for development..."
	JEKYLL_ENV=development $(JEKYLL) build

serve:
	@echo "Serving site locally on http://$(HOST):$(PORT) (livereload enabled)"
	$(JEKYLL) serve --host=$(HOST) --port=$(PORT) --livereload

serve-drafts:
	@echo "Serving site locally including drafts on http://$(HOST):$(PORT)"
	$(JEKYLL) serve --drafts --host=$(HOST) --port=$(PORT) --livereload

watch: serve

clean:
	@echo "Removing $(BUILD_DIR)..."
	rm -rf $(BUILD_DIR)

clean-deps:
	@echo "Removing bundler cache and Gemfile.lock (you will need to run 'make install' afterwards)"
	rm -rf vendor/cache Gemfile.lock

rebuild: clean build

open:
	@echo "Opening http://localhost:$(PORT)"
	python3 -m webbrowser "http://localhost:$(PORT)"

deploy: build
	@echo "Site built for production (check $(BUILD_DIR))"
