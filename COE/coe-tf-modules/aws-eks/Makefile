ENV = "dev"

gen-doc-principal:
	@terraform-docs markdown table --output-file README.md .

gen-doc-example:
	cd docs/examples/coe-default/
	@terraform-docs markdown table --output-file README.md .

gen-doc: gen-doc-principal gen-doc-example	 


testing:
	cd test/; go test -v -timeout 180m; cd ..