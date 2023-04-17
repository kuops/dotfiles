gitignore:
	@gibo dump core macOS > .gitignore
	@sed -i 's@# \*\.log@*.log@g' .gitignore
	@echo '.zshrc_work' >> .gitignore
