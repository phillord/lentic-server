test: install
	cask exec ert-runner

install:
	cask install

clean:
	rm -rf dist
