gitignore:
	@gibo dump core macOS > .gitignore
	@sed -i 's@# \*\.log@*.log@g' .gitignore
	@echo '' >> .gitignore
	@echo '.zshrc_work' >> .gitignore
	@echo 'iterm2/com.googlecode.iterm2.plist' >> .gitignore
