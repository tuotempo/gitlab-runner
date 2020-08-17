GITLAB_CHANGELOG_VERSION ?= master
GITLAB_CHANGELOG = .tmp/gitlab-changelog-$(GITLAB_CHANGELOG_VERSION)

.PHONY: generate_changelog
generate_changelog: export CHANGELOG_RELEASE ?= dev
generate_changelog: $(GITLAB_CHANGELOG)
	# Generating new changelog entries
	@$(GITLAB_CHANGELOG) -project-id 6329679 \
		-release $(CHANGELOG_RELEASE) \
		-starting-point-matcher "v[0-9]*.[0-9]*.[0-9]*" \
		-config-file .gitlab/changelog.yml \
		-changelog-file CHANGELOG.md

$(GITLAB_CHANGELOG): OS_TYPE ?= $(shell uname -s | tr '[:upper:]' '[:lower:]')
$(GITLAB_CHANGELOG): DOWNLOAD_URL = "https://storage.googleapis.com/gitlab-runner-tools/gitlab-changelog/$(GITLAB_CHANGELOG_VERSION)/gitlab-changelog-$(OS_TYPE)-amd64"
$(GITLAB_CHANGELOG):
	# Installing $(DOWNLOAD_URL) as $(GITLAB_CHANGELOG)
	@mkdir -p $(shell dirname $(GITLAB_CHANGELOG))
	@curl -sL "$(DOWNLOAD_URL)" -o "$(GITLAB_CHANGELOG)"
	@chmod +x "$(GITLAB_CHANGELOG)"

render: tests/*.yaml
	@for file in $^ ; do \
		helm template -n runner -f $${file} . > $${file}.rendered; \
	done

test: tests/*.yaml
	helm lint .

	@for file in $^ ; do \
		echo "Executing 'helm template' with $${file}"; \
		helm template -n runner -f $${file} . > /dev/null; \
		if [ $$? -ne 0 ]; then \
			echo "Executing "helm template" failed"; \
			exit 1; \
		fi; \
	done

	@for file in $^ ; do \
		echo "Checking 'helm template' $${file} matches $${file}.rendered"; \
		helm template -n runner -f $${file} . | git --no-pager diff --no-index -- $${file}.rendered -; \
		if [ $$? -ne 0 ]; then \
			echo "The rendered output of $${file} does not match $${file}.rendered - use "make render" to update."; \
		fi \
	done
