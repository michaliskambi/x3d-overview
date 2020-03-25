NAME:=x3d_overview
ALL_OUTPUT:=$(NAME).html $(NAME).pdf $(NAME).xml
#TEST_BROWSER:=firefox
TEST_BROWSER:=x-www-browser

all: $(ALL_OUTPUT)

$(NAME).html: $(NAME).adoc
	asciidoctor $< -o $@
	fpc -gl -gh patreon-link-insert.lpr
	./patreon-link-insert $@
	$(TEST_BROWSER) $@ &

$(NAME).xml: $(NAME).adoc
	asciidoctor $(ASCIIDOCTOR_LANGUAGE) -b docbook5 $< -o $@
#	yelp $@

$(NAME).pdf: $(NAME).xml
	fopub $(NAME).xml

# $(NAME).pdf: $(NAME).adoc
# 	asciidoctor-pdf $(NAME).adoc

.PHONY: clean
clean:
	rm -f $(ALL_OUTPUT)

SSH_TARGET:=michalis@ssh.castle-engine.io
SCP_TARGET:=$(SSH_TARGET):/home/michalis/cge-html/
HTML_BASE:=https://castle-engine.io/

.PHONY: upload
upload: clean all
	scp $(NAME).html $(NAME).pdf patreon-link.png $(SCP_TARGET)
	$(TEST_BROWSER) $(HTML_BASE)$(NAME).html &
	$(TEST_BROWSER) $(HTML_BASE)$(NAME).pdf &
	ssh $(SSH_TARGET) www_permissions.sh
