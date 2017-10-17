# Context for resources, e.g demo_v1, test_v1 and so on
RESOURCE_CONTEXT=v1
ELASTICSEARCH_URL=
REGION=eu-west-1
AWS_LOCAL_PROFILE=default
#############
# BUILD LAMBDA
#############

.PHONY: build
build:
	@echo "-----Building Lambda Backend function ------"
	cd function && npm install
	mkdir -p tmp
	aws cloudformation package --template-file service-cf.yaml --output-template-file tmp/cf-template.yaml --s3-bucket DEPLOYBUCKETNAME
	@echo "----Build Lambda Backend function  Done ----"

#############
# TEST
#############

.PHONY: test
test:
	@echo "Do your test step here...."

#############
# DEPLOY
#############

.PHONY: deploy
deploy: build
	@echo "Deploy"
	aws cloudformation deploy --template-file tmp/cf-template.yaml --stack-name overwatch-cwl-modesecurity-reader-$(RESOURCE_CONTEXT) --capabilities CAPABILITY_IAM --region $(REGION) --parameter-overrides  ResourceContext=$(RESOURCE_CONTEXT) ElasticSearchURL=$(ELASTICSEARCH_URL) --profile $(AWS_LOCAL_PROFILE)
	@echo "Deploy done"


#############
# CLEAN
#############
.PHONY: clean
