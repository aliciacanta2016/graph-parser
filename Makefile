# Convert GraphParser format to deplambda input format
convert_graphparser_to_deplambda_format:
	head -n915 data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.json | python scripts/convert-graph-parser-to-entity-mention-format.py > working/webquestions.train.txt
	tail -n200 data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.json | python scripts/convert-graph-parser-to-entity-mention-format.py > working/webquestions.dev.txt
	cat data/webquestions/webquestions.examples.test.domains.easyccg.parse.filtered.json | python scripts/convert-graph-parser-to-entity-mention-format.py > working/webquestions.test.txt
	head -n915 data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.noheuristics.json | python scripts/convert-graph-parser-to-entity-mention-format.py > working/webquestions.train.noheuristics.txt
	tail -n200 data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.noheuristics.json | python scripts/convert-graph-parser-to-entity-mention-format.py > working/webquestions.dev.noheuristics.txt
	cat data/webquestions/webquestions.examples.test.domains.easyccg.parse.filtered.noheuristics.json | python scripts/convert-graph-parser-to-entity-mention-format.py > working/webquestions.test.noheuristics.txt
	cat data/cai-yates-2013/question-and-logical-form-917/acl2014_domains/business_film_people_parse.txt | python scripts/convert-graph-parser-to-entity-mention-format.py > working/free917_business_film_people.txt

convert_graphparser_to_deplambda_format_tom:
	cat data/webquestions/webquestions.train.all.entity_annotated.txt | python scripts/convert-graph-parser-to-entity-mention-format_with_answers.py > working/webquestions.train.json.txt
	cat data/webquestions/webquestions.test.all.entity_annotated.txt | python scripts/convert-graph-parser-to-entity-mention-format_with_answers.py > working/webquestions.test.json.txt

convert_cai_yates_splits_to_deplambda:
	mkdir -p working/free917_business_film_people_splits
	cat data/cai-yates-2013/free917_business_film_people_splits/0.txt | python  scripts/convert-graph-parser-to-entity-mention-format.py > working/free917_business_film_people_splits/0.txt
	cat data/cai-yates-2013/free917_business_film_people_splits/1.txt | python  scripts/convert-graph-parser-to-entity-mention-format.py > working/free917_business_film_people_splits/1.txt
	cat data/cai-yates-2013/free917_business_film_people_splits/2.txt | python  scripts/convert-graph-parser-to-entity-mention-format.py > working/free917_business_film_people_splits/2.txt
	cat data/cai-yates-2013/free917_business_film_people_splits/3.txt | python  scripts/convert-graph-parser-to-entity-mention-format.py > working/free917_business_film_people_splits/3.txt
	cat data/cai-yates-2013/free917_business_film_people_splits/4.txt | python  scripts/convert-graph-parser-to-entity-mention-format.py > working/free917_business_film_people_splits/4.txt
	cat data/cai-yates-2013/free917_business_film_people_splits/5.txt | python  scripts/convert-graph-parser-to-entity-mention-format.py > working/free917_business_film_people_splits/5.txt
	cat data/cai-yates-2013/free917_business_film_people_splits/6.txt | python  scripts/convert-graph-parser-to-entity-mention-format.py > working/free917_business_film_people_splits/6.txt
	cat data/cai-yates-2013/free917_business_film_people_splits/7.txt | python  scripts/convert-graph-parser-to-entity-mention-format.py > working/free917_business_film_people_splits/7.txt
	cat data/cai-yates-2013/free917_business_film_people_splits/8.txt | python  scripts/convert-graph-parser-to-entity-mention-format.py > working/free917_business_film_people_splits/8.txt
	cat data/cai-yates-2013/free917_business_film_people_splits/9.txt | python  scripts/convert-graph-parser-to-entity-mention-format.py > working/free917_business_film_people_splits/9.txt

# Creates deplambda webquestions testing and training data
# If the tokenization is disabled in the workflow, you will be able to use all
# the examples, or else some of the examples cannot be used.
create_deplambda_supervised_input_data:
# zcat data/freebase/sentences_filtered/film_sentences.txt.gz | python scripts/dump_sentences.py | sed -e 's/_/ /g' | sed -e 's/\ ,/,/g' | sed -e 's/\ \././g' | sed -e "s/\ 's/'s/g" | sed -e "s/ n't/n't/g" | sed -e "s/ \!/\!/g" | grep -v "\?" | sed -e "s/ -/-/g" | sed -e "s/- /-/g" | sed -e "s/ '/'/g" | gzip > google_graphparser_data/film_sentences.txt.gz
	cat data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.json | python scripts/dump_sentences.py > data/deplambda/webquestions.train.txt
	cat data/webquestions/webquestions.examples.test.domains.easyccg.parse.filtered.json | python scripts/dump_sentences.py > data/deplambda/webquestions.test.txt
	cat data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.json data/webquestions/webquestions.examples.test.domains.easyccg.parse.filtered.json | python scripts/dependency_semantic_parser/create_entity_lexicon.py > data/deplambda/entity_lexicon.txt

# Copies all documents from oscar's cns to current folder.
copy_deplambda_output:
	rm data/deplambda/webquestions.test.documents.txt
	rm data/deplambda/webquestions.train.documents.txt
	rm -r data/deplambda/unsupervised
	fileutil cp /cns/lb-d/home/oscart/e/siva-tacl-data/graphparser-questions-test/output data/deplambda/webquestions.test.documents.txt
	fileutil cp /cns/lb-d/home/oscart/e/siva-tacl-data/graphparser-questions-train/output data/deplambda/webquestions.train.documents.txt
	fileutil cp /cns/lb-d/home/oscart/e/siva-tacl-data/graphparser-lambda-expressions/* data/deplambda/unsupervised

# Converts deplambda documents in json format to graphparsers json format.
convert_deplambda_output_to_graphparser:
	#cat data/deplambda/training/* \
	#| python scripts/dependency_semantic_parser/convert_document_json_graphparser_json.py \
	#| python scripts/cleaning/remove_duplicate_sentences.py \
	#| gzip > data/deplambda/unsupervised.graphparser.txt.gz
	cat data/deplambda/wq-train-documents.json \
	| python scripts/dependency_semantic_parser/convert_document_json_graphparser_json.py \
	| python scripts/dependency_semantic_parser/add_answers.py data/tacl/webquestions.examples.train.domains.easyccg.parse.filtered.json.train.915 \
	> data/deplambda/webquestions.train.graphparser.txt
	cat data/deplambda/wq-dev-documents.json \
	| python scripts/dependency_semantic_parser/convert_document_json_graphparser_json.py \
	| python scripts/dependency_semantic_parser/add_answers.py data/tacl/webquestions.examples.train.domains.easyccg.parse.filtered.json.dev.200 \
	> data/deplambda/webquestions.dev.graphparser.txt
	cat data/deplambda/wq-test-documents.json \
	| python scripts/dependency_semantic_parser/convert_document_json_graphparser_json.py \
	| python scripts/dependency_semantic_parser/add_answers.py data/tacl/webquestions.examples.test.domains.easyccg.parse.filtered.json \
	> data/deplambda/webquestions.test.graphparser.txt
	cat data/deplambda/free917-documents.json \
	| python scripts/dependency_semantic_parser/convert_document_json_graphparser_json.py \
	| python scripts/dependency_semantic_parser/add_answers.py data/cai-yates-2013/question-and-logical-form-917/acl2014_domains/business_film_people_parse.txt \
	> data/deplambda/free917.txt

# Create dependency based grounded lexicon.
# Unfortunately, this cannot run parallel version since I have to write
# sentences into a single file.
create_deplambda_grounded_lexicon:
	mkdir -p data/deplambda/sentences_training
	mkdir -p data/deplambda/grounded_lexicon
	zcat data/deplambda/unsupervised.graphparser.txt.gz \
	| python scripts/cleaning/remove_duplicate_sentences.py \
	| java -Xms2048m -cp lib/*:graph-parser.jar in.sivareddy.graphparser.cli.RunPrintDomainLexicon \
	--relationLexicalIdentifiers lemma \
	--semanticParseKey dependency_lambda \
	--argumentLexicalIdentifiers mid \
	--relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	--kbZipFile data/freebase/domain_facts/business_film_people_facts.txt.gz \
	--outputLexiconFile data/deplambda/grounded_lexicon/deplambda_grounded_lexicon.txt \
	| python scripts/freebase-training/filter_training_sentences.py 0 0 0 0 0 \
	| python scripts/cleaning/remove_duplicate_sentences.py \
	| gzip > data/deplambda/sentences_training/deplambda_training_sentences.txt.gz

# Create ccg based grounded lexicon.
create_ccg_grounded_lexicon:
	mkdir -p data/deplambda/sentences_training
	mkdir -p data/deplambda/grounded_lexicon
	zcat data/deplambda/unsupervised.graphparser.txt.gz \
	| python scripts/cleaning/remove_duplicate_sentences.py \
	| java -Xms2048m -cp lib/*:graph-parser.jar in.sivareddy.graphparser.cli.RunPrintDomainLexicon \
	--relationLexicalIdentifiers lemma \
	--semanticParseKey ccg_lambda \
	--argumentLexicalIdentifiers mid \
	--relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	--kbZipFile data/freebase/domain_facts/business_film_people_facts.txt.gz \
	--outputLexiconFile data/deplambda/grounded_lexicon/ccg_grounded_lexicon.txt \
	| python scripts/freebase-training/filter_training_sentences.py 0 0 0 0 0 \
	| python scripts/cleaning/remove_duplicate_sentences.py \
	| gzip > data/deplambda/sentences_training/ccg_training_sentences.txt.gz

# TACL CCG lexicon and training sentences
create_tacl_ccg_grounded_lexicon_and_training_sentences:
	mkdir -p data/tacl/sentences_training
	mkdir -p data/tacl/grounded_lexicon
	zcat data/freebase/sentences_filtered/* \
	| python scripts/cleaning/remove_duplicate_sentences.py \
	| java -Xms2048m -cp lib/*:graph-parser.jar in.sivareddy.graphparser.cli.RunPrintDomainLexicon \
	--relationLexicalIdentifiers lemma \
	--semanticParseKey synPars \
	--argumentLexicalIdentifiers mid \
	--candcIndexFile lib_data/candc_markedup.modified \
	--unaryRulesFile lib_data/unary_rules.txt \
	--binaryRulesFile lib_data/binary_rules.txt \
	--specialCasesFile lib_data/lexicon_specialCases.txt \
	--relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	--kbZipFile data/freebase/domain_facts/business_film_people_facts.txt.gz \
	--outputLexiconFile data/tacl/grounded_lexicon/tacl_grounded_lexicon.txt \
	| python scripts/freebase-training/filter_training_sentences.py 0 0 0 0 0 \
	| python scripts/cleaning/remove_duplicate_sentences.py \
	| gzip > data/tacl/sentences_training/tacl_training_sentences.txt.gz

# TACL CCG lexicon and training sentences
create_tacl_ccg_grounded_lexicon_and_training_sentences_%:
	mkdir -p data/tacl/sentences_training
	mkdir -p data/tacl/grounded_lexicon
	zcat data/freebase/sentences_filtered/$*_sentences.txt.gz \
	| python scripts/cleaning/remove_duplicate_sentences.py \
	| java -Xms2048m -cp lib/*:graph-parser.jar in.sivareddy.graphparser.cli.RunPrintDomainLexicon \
	--relationLexicalIdentifiers lemma \
	--semanticParseKey synPars \
	--argumentLexicalIdentifiers mid \
	--candcIndexFile lib_data/candc_markedup.modified \
	--unaryRulesFile lib_data/unary_rules.txt \
	--binaryRulesFile lib_data/binary_rules.txt \
	--specialCasesFile lib_data/lexicon_specialCases.txt \
	--relationTypesFile data/freebase/stats/$*_relation_types.txt \
	--kbZipFile data/freebase/domain_facts/$*_facts.txt.gz \
	--outputLexiconFile data/tacl/grounded_lexicon/$*_tacl_grounded_lexicon.txt \
	| python scripts/freebase-training/filter_training_sentences.py 0 0 0 0 0 \
	| python scripts/cleaning/remove_duplicate_sentences.py \
	| gzip > data/tacl/sentences_training/$*_tacl_training_sentences.txt.gz

create_tacl_ccg_grounded_lexicon_and_training_sentences_individual:
	make create_tacl_ccg_grounded_lexicon_and_training_sentences_business
	make create_tacl_ccg_grounded_lexicon_and_training_sentences_film
	make create_tacl_ccg_grounded_lexicon_and_training_sentences_people

merge_lexicon_individual:
	python scripts/freebase/merge_lexicon.py \
	data/tacl/grounded_lexicon/business_tacl_grounded_lexicon.txt \
	data/tacl/grounded_lexicon/film_tacl_grounded_lexicon.txt \
	data/tacl/grounded_lexicon/people_tacl_grounded_lexicon.txt \
	> data/tacl/grounded_lexicon/business_film_people_merged_tacl_grounded_lexicon.txt

# Deplambda Experiments
# Baseline to evaluate the accuracy of lexicon
deplambda_mwg:
	mkdir -p working/deplambda_mwg
	java -Xms2048m -cp lib/*:graph-parser.jar in.sivareddy.graphparser.cli.RunGraphToQueryTrainingMain \
	-semanticParseKey dependency_lambda \
	-schema data/freebase/schema/business_film_people_schema.txt \
	-relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	-lexicon data/deplambda/grounded_lexicon/deplambda_grounded_lexicon.txt \
	-cachedKB data/freebase/domain_facts/business_film_people_facts.txt.gz \
	-domain "http://business.freebase.com;http://film.freebase.com;http://people.freebase.com" \
	-nthreads 10 \
	-iterations 1 \
	-nbestGraphs 100 \
	-useSchema true \
	-useKB true \
	-groundFreeVariables false \
	-useEmptyTypes false \
	-ignoreTypes true \
	-urelGrelFlag true \
	-urelPartGrelPartFlag false \
	-utypeGtypeFlag true \
	-wordGrelPartFlag false \
	-wordBigramGrelPartFlag true \
	-argGrelPartFlag true \
	-stemMatchingFlag true \
	-mediatorStemGrelPartMatchingFlag true \
	-argumentStemMatchingFlag true \
	-argumentStemGrelPartMatchingFlag true \
	-graphIsConnectedFlag false \
	-graphHasEdgeFlag true \
	-countNodesFlag false \
	-edgeNodeCountFlag false \
	-duplicateEdgesFlag true \
	-grelGrelFlag true \
	-useLexiconWeightsRel true \
	-useLexiconWeightsType false \
	-validQueryFlag false \
	-initialEdgeWeight 1.0 \
	-initialTypeWeight -1.0 \
	-initialWordWeight 1.0 \
	-stemFeaturesWeight 0.0 \
	-endpoint stkilda \
	-devFile data/deplambda/webquestions.dev.graphparser.txt \
	-testFile data/deplambda/webquestions.test.graphparser.txt \
	-logFile working/deplambda_mwg/business_film_people.log.txt \
	> working/deplambda_mwg/business_film_people.txt

deplambda_mwg_on_training_data:
	mkdir -p working/deplambda_mwg_on_training
	java -Xms2048m -cp lib/*:graph-parser.jar in.sivareddy.graphparser.cli.RunGraphToQueryTrainingMain \
	-semanticParseKey dependency_lambda \
	-schema data/freebase/schema/business_film_people_schema.txt \
	-relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	-lexicon data/deplambda/grounded_lexicon/deplambda_grounded_lexicon.txt \
	-cachedKB data/freebase/domain_facts/business_film_people_facts.txt.gz \
	-domain "http://business.freebase.com;http://film.freebase.com;http://people.freebase.com" \
	-nthreads 20 \
	-iterations 1 \
	-nbestGraphs 100 \
	-useSchema true \
	-useKB true \
	-groundFreeVariables false \
	-useEmptyTypes false \
	-ignoreTypes true \
	-urelGrelFlag true \
	-urelPartGrelPartFlag false \
	-utypeGtypeFlag true \
	-wordGrelPartFlag false \
	-wordBigramGrelPartFlag true \
	-argGrelPartFlag true \
	-stemMatchingFlag true \
	-mediatorStemGrelPartMatchingFlag true \
	-argumentStemMatchingFlag true \
	-argumentStemGrelPartMatchingFlag true \
	-graphIsConnectedFlag false \
	-graphHasEdgeFlag true \
	-countNodesFlag false \
	-edgeNodeCountFlag false \
	-duplicateEdgesFlag true \
	-grelGrelFlag true \
	-useLexiconWeightsRel true \
	-useLexiconWeightsType false \
	-validQueryFlag false \
	-initialEdgeWeight 1.0 \
	-initialTypeWeight -1.0 \
	-initialWordWeight 1.0 \
	-stemFeaturesWeight 0.0 \
	-endpoint bravas \
	-devFile data/deplambda/webquestions.train.graphparser.txt \
	-testFile data/deplambda/webquestions.test.graphparser.txt \
	-logFile working/deplambda_mwg_on_training/business_film_people.log.txt \
	> working/deplambda_mwg_on_training/business_film_people.txt

deplambda_mwg_free917:
	mkdir -p working/deplambda_mwg_free917
	java -Xms2048m -cp lib/*:graph-parser.jar in.sivareddy.graphparser.cli.RunGraphToQueryTrainingMain \
	-semanticParseKey dependency_lambda \
	-schema data/freebase/schema/business_film_people_schema.txt \
	-relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	-lexicon data/deplambda/grounded_lexicon/deplambda_grounded_lexicon.txt \
	-cachedKB data/freebase/domain_facts/business_film_people_facts.txt.gz \
	-domain "http://business.freebase.com;http://film.freebase.com;http://people.freebase.com" \
	-nthreads 10 \
	-iterations 1 \
	-nbestGraphs 100 \
	-useSchema true \
	-useKB true \
	-groundFreeVariables false \
	-useEmptyTypes false \
	-ignoreTypes true \
	-urelGrelFlag true \
	-urelPartGrelPartFlag false \
	-utypeGtypeFlag true \
	-wordGrelPartFlag false \
	-wordBigramGrelPartFlag true \
	-argGrelPartFlag true \
	-stemMatchingFlag true \
	-mediatorStemGrelPartMatchingFlag true \
	-argumentStemMatchingFlag true \
	-argumentStemGrelPartMatchingFlag true \
	-graphIsConnectedFlag false \
	-graphHasEdgeFlag true \
	-countNodesFlag false \
	-edgeNodeCountFlag false \
	-duplicateEdgesFlag true \
	-grelGrelFlag true \
	-useLexiconWeightsRel true \
	-useLexiconWeightsType false \
	-validQueryFlag false \
	-initialEdgeWeight 1.0 \
	-initialTypeWeight -1.0 \
	-initialWordWeight 1.0 \
	-stemFeaturesWeight 0.0 \
	-endpoint stkilda \
	-devFile data/deplambda/free917.txt \
	-logFile working/deplambda_mwg_free917/business_film_people.log.txt \
	> working/deplambda_mwg_free917/business_film_people.txt

ccg_mwg:
	mkdir -p working/ccg_mwg
	java -Xms2048m -cp lib/*:graph-parser.jar in.sivareddy.graphparser.cli.RunGraphToQueryTrainingMain \
	-semanticParseKey ccg_lambda \
	-schema data/freebase/schema/business_film_people_schema.txt \
	-relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	-lexicon data/deplambda/grounded_lexicon/ccg_grounded_lexicon.txt \
	-cachedKB data/freebase/domain_facts/business_film_people_facts.txt.gz \
	-domain "http://business.freebase.com;http://film.freebase.com;http://people.freebase.com" \
	-nthreads 10 \
	-iterations 1 \
	-nbestGraphs 100 \
	-useSchema true \
	-useKB true \
	-groundFreeVariables false \
	-useEmptyTypes false \
	-ignoreTypes true \
	-urelGrelFlag true \
	-urelPartGrelPartFlag false \
	-utypeGtypeFlag true \
	-wordGrelPartFlag false \
	-wordBigramGrelPartFlag true \
	-argGrelPartFlag true \
	-stemMatchingFlag true \
	-mediatorStemGrelPartMatchingFlag true \
	-argumentStemMatchingFlag true \
	-argumentStemGrelPartMatchingFlag true \
	-graphIsConnectedFlag false \
	-graphHasEdgeFlag true \
	-countNodesFlag false \
	-edgeNodeCountFlag false \
	-duplicateEdgesFlag true \
	-grelGrelFlag true \
	-useLexiconWeightsRel true \
	-useLexiconWeightsType false \
	-validQueryFlag false \
	-initialEdgeWeight 1.0 \
	-initialTypeWeight -1.0 \
	-initialWordWeight 1.0 \
	-stemFeaturesWeight 0.0 \
	-endpoint darkstar \
	-devFile data/deplambda/webquestions.train.graphparser.txt.200 \
	-testFile data/deplambda/webquestions.test.graphparser.txt \
	-logFile working/ccg_mwg/business_film_people.log.txt \
	> working/ccg_mwg/business_film_people.txt

ccg_mwg_free917:
	mkdir -p working/ccg_mwg_free917
	java -Xms2048m -cp lib/*:graph-parser.jar in.sivareddy.graphparser.cli.RunGraphToQueryTrainingMain \
	-semanticParseKey ccg_lambda \
	-schema data/freebase/schema/business_film_people_schema.txt \
	-relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	-lexicon data/deplambda/grounded_lexicon/ccg_grounded_lexicon.txt \
	-cachedKB data/freebase/domain_facts/business_film_people_facts.txt.gz \
	-domain "http://business.freebase.com;http://film.freebase.com;http://people.freebase.com" \
	-nthreads 10 \
	-iterations 1 \
	-nbestGraphs 100 \
	-useSchema true \
	-useKB true \
	-groundFreeVariables false \
	-useEmptyTypes false \
	-ignoreTypes true \
	-urelGrelFlag true \
	-urelPartGrelPartFlag false \
	-utypeGtypeFlag true \
	-wordGrelPartFlag false \
	-wordBigramGrelPartFlag true \
	-argGrelPartFlag true \
	-stemMatchingFlag true \
	-mediatorStemGrelPartMatchingFlag true \
	-argumentStemMatchingFlag true \
	-argumentStemGrelPartMatchingFlag true \
	-graphIsConnectedFlag false \
	-graphHasEdgeFlag true \
	-countNodesFlag false \
	-edgeNodeCountFlag false \
	-duplicateEdgesFlag true \
	-grelGrelFlag true \
	-useLexiconWeightsRel true \
	-useLexiconWeightsType false \
	-validQueryFlag false \
	-initialEdgeWeight 1.0 \
	-initialTypeWeight -1.0 \
	-initialWordWeight 1.0 \
	-stemFeaturesWeight 0.0 \
	-endpoint bravas \
	-devFile data/deplambda/free917.txt \
	-logFile working/ccg_mwg_free917/business_film_people.log.txt \
	> working/ccg_mwg_free917/business_film_people.txt

# Supervised Expermients
# Deplambda results without unsupervised lexicon.
deplambda_supervised:
	mkdir -p working/deplambda_supervised
	java -Xms2048m -Xmx20g -cp .:graph-parser.jar in.sivareddy.graphparser.cli.RunGraphToQueryTrainingMain \
	-schema data/freebase/schema/business_film_people_schema.txt \
	-relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	-lexicon data/dummy.txt \
	-cachedKB data/freebase/domain_facts/business_facts.txt.gz \
	-domain "http://business.freebase.com;http://film.freebase.com;http://people.freebase.com" \
	-nthreads 1 \
	-trainingSampleSize 600 \
	-iterations 20 \
	-nBestTrainSyntacticParses 1 \
	-nBestTestSyntacticParses 1 \
	-nbestGraphs 500 \
	-useSchema true \
	-useKB true \
	-groundFreeVariables true \
	-useEmptyTypes true \
	-ignoreTypes false \
	-urelGrelFlag true \
	-urelPartGrelPartFlag false \
	-utypeGtypeFlag true \
	-gtypeGrelFlag false \
	-wordGrelPartFlag false \
	-wordBigramGrelPartFlag false \
	-argGrelPartFlag false \
	-stemMatchingFlag true \
	-mediatorStemGrelPartMatchingFlag true \
	-argumentStemMatchingFlag true \
	-argumentStemGrelPartMatchingFlag true \
	-graphIsConnectedFlag false \
	-graphHasEdgeFlag true \
	-countNodesFlag false \
	-edgeNodeCountFlag false \
	-duplicateEdgesFlag true \
	-grelGrelFlag true \
	-useLexiconWeightsRel true \
	-useLexiconWeightsType true \
	-validQueryFlag true \
	-initialEdgeWeight 1.0 \
	-initialTypeWeight 1.0 \
	-initialWordWeight -0.05 \
	-stemFeaturesWeight 0.0 \
	-endpoint oscart.hot.corp.google.com \
	-semanticParseKey dependency_lambda \
	-trainingCorpora "data/dummy.txt.gz" \
	-supervisedCorpus data/deplambda/webquestions.train.graphparser.txt \
	-testFile data/deplambda/webquestions.test.graphparser.txt \
	-logFile working/deplambda_supervised/business_film_people.log.txt \
	> working/deplambda_supervised/business_film_people.txt

# CCG Supervised Results without unsupervised lexicon.
ccg_supervised:
	mkdir -p working/ccg_supervised
	java -Xms2048m -Xmx20g -cp .:graph-parser.jar in.sivareddy.graphparser.cli.RunGraphToQueryTrainingMain \
	-schema data/freebase/schema/business_film_people_schema.txt \
	-relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	-lexicon data/dummy.txt \
	-cachedKB data/freebase/domain_facts/business_facts.txt.gz \
	-domain "http://business.freebase.com;http://film.freebase.com;http://people.freebase.com" \
	-nthreads 1 \
	-trainingSampleSize 600 \
	-iterations 20 \
	-nBestTrainSyntacticParses 1 \
	-nBestTestSyntacticParses 1 \
	-nbestGraphs 500 \
	-useSchema true \
	-useKB true \
	-groundFreeVariables true \
	-useEmptyTypes true \
	-ignoreTypes false \
	-urelGrelFlag true \
	-urelPartGrelPartFlag false \
	-utypeGtypeFlag true \
	-gtypeGrelFlag false \
	-wordGrelPartFlag false \
	-wordBigramGrelPartFlag false \
	-argGrelPartFlag false \
	-stemMatchingFlag true \
	-mediatorStemGrelPartMatchingFlag true \
	-argumentStemMatchingFlag true \
	-argumentStemGrelPartMatchingFlag true \
	-graphIsConnectedFlag false \
	-graphHasEdgeFlag true \
	-countNodesFlag false \
	-edgeNodeCountFlag false \
	-duplicateEdgesFlag true \
	-grelGrelFlag true \
	-useLexiconWeightsRel true \
	-useLexiconWeightsType true \
	-validQueryFlag true \
	-initialEdgeWeight 1.0 \
	-initialTypeWeight 1.0 \
	-initialWordWeight -0.05 \
	-stemFeaturesWeight 0.0 \
	-endpoint oscart.hot.corp.google.com \
	-semanticParseKey ccg_lambda \
	-trainingCorpora "data/dummy.txt.gz" \
	-supervisedCorpus data/deplambda/webquestions.train.graphparser.txt \
	-testFile data/deplambda/webquestions.test.graphparser.txt \
	-logFile working/ccg_supervised/business_film_people.log.txt \
	> working/ccg_supervised/business_film_people.txt

# Deplambda results with unsupervised lexicon.
deplambda_supervised_with_unsupervised_lexicon:
	mkdir -p working/deplambda_supervised_with_unsupervised_lexicon
	java -Xms2048m -Xmx20g -cp .:graph-parser.jar in.sivareddy.graphparser.cli.RunGraphToQueryTrainingMain \
	-schema data/freebase/schema/business_film_people_schema.txt \
	-relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	-lexicon data/deplambda/grounded_lexicon/deplambda_grounded_lexicon.txt \
	-cachedKB data/freebase/domain_facts/business_facts.txt.gz \
	-domain "http://business.freebase.com;http://film.freebase.com;http://people.freebase.com" \
	-nthreads 1 \
	-trainingSampleSize 600 \
	-iterations 20 \
	-nBestTrainSyntacticParses 1 \
	-nBestTestSyntacticParses 1 \
	-nbestGraphs 500 \
	-useSchema true \
	-useKB true \
	-groundFreeVariables true \
	-useEmptyTypes true \
	-ignoreTypes false \
	-urelGrelFlag true \
	-urelPartGrelPartFlag false \
	-utypeGtypeFlag true \
	-gtypeGrelFlag false \
	-wordGrelPartFlag false \
	-wordBigramGrelPartFlag false \
	-argGrelPartFlag false \
	-stemMatchingFlag true \
	-mediatorStemGrelPartMatchingFlag true \
	-argumentStemMatchingFlag true \
	-argumentStemGrelPartMatchingFlag true \
	-graphIsConnectedFlag false \
	-graphHasEdgeFlag true \
	-countNodesFlag false \
	-edgeNodeCountFlag false \
	-duplicateEdgesFlag true \
	-grelGrelFlag true \
	-useLexiconWeightsRel true \
	-useLexiconWeightsType true \
	-validQueryFlag true \
	-initialEdgeWeight 1.0 \
	-initialTypeWeight 1.0 \
	-initialWordWeight -0.05 \
	-stemFeaturesWeight 0.0 \
	-endpoint oscart.hot.corp.google.com \
	-semanticParseKey dependency_lambda \
	-trainingCorpora "data/dummy.txt.gz" \
	-supervisedCorpus data/deplambda/webquestions.train.graphparser.txt \
	-testFile data/deplambda/webquestions.test.graphparser.txt \
	-logFile working/deplambda_supervised_with_unsupervised_lexicon/business_film_people.log.txt \
	> working/deplambda_supervised_with_unsupervised_lexicon/business_film_people.txt

# CCG Supervised Results with unsupervised lexicon.
ccg_supervised_with_unsupervised_lexicon:
	mkdir -p working/ccg_supervised_with_unsupervised_lexicon
	java -Xms2048m -Xmx20g -cp .:graph-parser.jar in.sivareddy.graphparser.cli.RunGraphToQueryTrainingMain \
	-schema data/freebase/schema/business_film_people_schema.txt \
	-relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	-lexicon data/deplambda/grounded_lexicon/ccg_grounded_lexicon.txt \
	-cachedKB data/freebase/domain_facts/business_facts.txt.gz \
	-domain "http://business.freebase.com;http://film.freebase.com;http://people.freebase.com" \
	-nthreads 1 \
	-trainingSampleSize 600 \
	-iterations 20 \
	-nBestTrainSyntacticParses 1 \
	-nBestTestSyntacticParses 1 \
	-nbestGraphs 500 \
	-useSchema true \
	-useKB true \
	-groundFreeVariables true \
	-useEmptyTypes true \
	-ignoreTypes false \
	-urelGrelFlag true \
	-urelPartGrelPartFlag false \
	-utypeGtypeFlag true \
	-gtypeGrelFlag false \
	-wordGrelPartFlag false \
	-wordBigramGrelPartFlag false \
	-argGrelPartFlag false \
	-stemMatchingFlag true \
	-mediatorStemGrelPartMatchingFlag true \
	-argumentStemMatchingFlag true \
	-argumentStemGrelPartMatchingFlag true \
	-graphIsConnectedFlag false \
	-graphHasEdgeFlag true \
	-countNodesFlag false \
	-edgeNodeCountFlag false \
	-duplicateEdgesFlag true \
	-grelGrelFlag true \
	-useLexiconWeightsRel true \
	-useLexiconWeightsType true \
	-validQueryFlag true \
	-initialEdgeWeight 1.0 \
	-initialTypeWeight 1.0 \
	-initialWordWeight -0.05 \
	-stemFeaturesWeight 0.0 \
	-endpoint oscart.hot.corp.google.com \
	-semanticParseKey ccg_lambda \
	-trainingCorpora "data/dummy.txt.gz" \
	-supervisedCorpus data/deplambda/webquestions.train.graphparser.txt \
	-testFile data/deplambda/webquestions.test.graphparser.txt \
	-logFile working/ccg_supervised_with_unsupervised_lexicon/business_film_people.log.txt \
	> working/ccg_supervised_with_unsupervised_lexicon/business_film_people.txt

# deplambda with unsupervised training
deplambda_unsupervised:
	mkdir -p working/deplambda_unsupervised
	java -Xms2048m -Xmx20g -cp .:graph-parser.jar in.sivareddy.graphparser.cli.RunGraphToQueryTrainingMain \
	-schema data/freebase/schema/business_film_people_schema.txt \
	-relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	-lexicon data/deplambda/grounded_lexicon/deplambda_grounded_lexicon.txt \
	-cachedKB data/freebase/domain_facts/business_facts.txt.gz \
	-domain "http://business.freebase.com;http://film.freebase.com;http://people.freebase.com" \
	-nthreads 1 \
	-trainingSampleSize 600 \
	-iterations 20 \
	-nBestTrainSyntacticParses 1 \
	-nBestTestSyntacticParses 1 \
	-nbestGraphs 500 \
	-useSchema true \
	-useKB true \
	-groundFreeVariables true \
	-useEmptyTypes true \
	-ignoreTypes false \
	-urelGrelFlag true \
	-urelPartGrelPartFlag false \
	-utypeGtypeFlag true \
	-gtypeGrelFlag false \
	-wordGrelPartFlag false \
	-wordBigramGrelPartFlag false \
	-argGrelPartFlag false \
	-stemMatchingFlag true \
	-mediatorStemGrelPartMatchingFlag true \
	-argumentStemMatchingFlag true \
	-argumentStemGrelPartMatchingFlag true \
	-graphIsConnectedFlag false \
	-graphHasEdgeFlag true \
	-countNodesFlag false \
	-edgeNodeCountFlag false \
	-duplicateEdgesFlag true \
	-grelGrelFlag true \
	-useLexiconWeightsRel true \
	-useLexiconWeightsType true \
	-validQueryFlag true \
	-initialEdgeWeight 1.0 \
	-initialTypeWeight 1.0 \
	-initialWordWeight -0.05 \
	-stemFeaturesWeight 0.0 \
	-endpoint oscart.hot.corp.google.com \
	-semanticParseKey dependency_lambda \
	-trainingCorpora "TODO" \
	-supervisedCorpus data/deplambda/webquestions.train.graphparser.txt \
	-testFile data/deplambda/webquestions.test.graphparser.txt \
	-logFile working/deplambda_unsupervised/business_film_people.log.txt \
	> working/deplambda_unsupervised/business_film_people.txt

# ccg with unsupervised training.
ccg_unsupervised:
	mkdir -p working/ccg_unsupervised
	java -Xms2048m -Xmx20g -cp .:graph-parser.jar in.sivareddy.graphparser.cli.RunGraphToQueryTrainingMain \
	-schema data/freebase/schema/business_film_people_schema.txt \
	-relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	-lexicon data/deplambda/grounded_lexicon/ccg_grounded_lexicon.txt \
	-cachedKB data/freebase/domain_facts/business_facts.txt.gz \
	-domain "http://business.freebase.com;http://film.freebase.com;http://people.freebase.com" \
	-nthreads 1 \
	-trainingSampleSize 600 \
	-iterations 20 \
	-nBestTrainSyntacticParses 1 \
	-nBestTestSyntacticParses 1 \
	-nbestGraphs 500 \
	-useSchema true \
	-useKB true \
	-groundFreeVariables true \
	-useEmptyTypes true \
	-ignoreTypes false \
	-urelGrelFlag true \
	-urelPartGrelPartFlag false \
	-utypeGtypeFlag true \
	-gtypeGrelFlag false \
	-wordGrelPartFlag false \
	-wordBigramGrelPartFlag false \
	-argGrelPartFlag false \
	-stemMatchingFlag true \
	-mediatorStemGrelPartMatchingFlag true \
	-argumentStemMatchingFlag true \
	-argumentStemGrelPartMatchingFlag true \
	-graphIsConnectedFlag false \
	-graphHasEdgeFlag true \
	-countNodesFlag false \
	-edgeNodeCountFlag false \
	-duplicateEdgesFlag true \
	-grelGrelFlag true \
	-useLexiconWeightsRel true \
	-useLexiconWeightsType true \
	-validQueryFlag true \
	-initialEdgeWeight 1.0 \
	-initialTypeWeight 1.0 \
	-initialWordWeight -0.05 \
	-stemFeaturesWeight 0.0 \
	-endpoint oscart.hot.corp.google.com \
	-semanticParseKey ccg_lambda \
	-trainingCorpora "TODO" \
	-testFile data/deplambda/webquestions.test.graphparser.txt \
	-logFile working/ccg_unsupervised/business_film_people.log.txt \
	> working/ccg_unsupervised/business_film_people.txt

############################################### TACL Experiments  ################################################

# Ignore
create_grounded_lexicon_and_filter_sentences_%:
	mkdir -p data/freebase/sentences_training
	mkdir -p data/freebase/grounded_lexicon
	zcat data/freebase/sentences_filtered/$*_sentences.txt.gz \
	| java -Xms2048m -cp .:GraphParser.jar in.sivareddy.graphparser.cli.RunPrintDomainLexicon \
	--relationLexicalIdentifiers lemma \
	--argumentLexicalIdentifiers mid \
	--candcIndexFile data/candc_markedup.modified \
	--unaryRulesFile data/unary_rules.txt \
	--binaryRulesFile data/binary_rules.txt \
	--specialCasesFile data/lexicon_specialCases.txt \
	--relationTypesFile data/freebase/stats/$*_relation_types.txt \
	--kbZipFile data/freebase/domain_facts/$*_facts.txt.gz \
	--outputLexiconFile data/freebase/grounded_lexicon/$*_grounded_lexicon.txt \
	| gzip > data/freebase/sentences_training/$*_training_sentences.txt.gz

# Create training data and grounded lexicon
create_grounded_lexicon_and_filter_sentences:
	make create_grounded_lexicon_and_filter_sentences_business
	make create_grounded_lexicon_and_filter_sentences_film
	make create_grounded_lexicon_and_filter_sentences_people

# Ignore
filter_training_sentences_%:
	mkdir -p data/freebase/sentences_training_filtered
	zcat data/freebase/sentences_training/$*_training_sentences.txt.gz \
	|  python scripts/freebase-training/filter_training_sentences.py 0 0 0 0 0 \
	| gzip >  data/freebase/sentences_training_filtered/$*_training_sentences_filtered_00000.txt.gz

# filter training sentences - These are used for training
filter_training_sentences:
	make filter_training_sentences_business
	make filter_training_sentences_film
	make filter_training_sentences_people

# Merge lexicons
merge_lexicon:
	python scripts/freebase/merge_lexicon.py \
	data/freebase/grounded_lexicon/business_grounded_lexicon.txt \
	data/freebase/grounded_lexicon/film_grounded_lexicon.txt \
	data/freebase/grounded_lexicon/people_grounded_lexicon.txt \
	> data/freebase/grounded_lexicon/tacl_merged_grounded_lexicon.txt

# Web Questions Experiments

# Parse webquestions.
parse_webquestions_easyccg:
	cat data/webquestions/webquestions.examples.test.domains.filtered.json \
	| python scripts/webquestions-preprocessing/tokenise.py \
	| python scripts/webquestions-preprocessing/tag_named_entities_normal.py data/webquestions/webquestions.examples.test.domains.manual.lexicon \
	| java -cp .:tools/stanford-ner-2012-11-11/stanford-ner.jar:tools/stanford-ner-2012-11-11/gson-2.2.2.jar:tools/stanford-ner-2012-11-11/guava-14.0.1.jar:scripts NerJsonInputData \
	| python scripts/cleaning/ner_post_process.py \
	| python scripts/webquestions-preprocessing/non_copulize.py \
	| python scripts/webquestions-preprocessing/run_candc_tagger_ner_on_json_sentences_questions.py questions \
	| python scripts/webquestions-preprocessing/run_easyccg_parser_on_json_sentences_questions.py questions \
	> data/webquestions/webquestions.examples.test.domains.easyccg.parse.filtered.json
	
	cat data/webquestions/webquestions.examples.train.domains.filtered.json \
	| python scripts/webquestions-preprocessing/tokenise.py \
	| python scripts/webquestions-preprocessing/tag_named_entities_normal.py data/webquestions/webquestions.examples.train.domains.manual.lexicon \
	| java -cp .:tools/stanford-ner-2012-11-11/stanford-ner.jar:tools/stanford-ner-2012-11-11/gson-2.2.2.jar:tools/stanford-ner-2012-11-11/guava-14.0.1.jar:scripts NerJsonInputData \
	| python scripts/cleaning/ner_post_process.py \
	| python scripts/webquestions-preprocessing/non_copulize.py \
	| python scripts/webquestions-preprocessing/run_candc_tagger_ner_on_json_sentences_questions.py questions \
	| python scripts/webquestions-preprocessing/run_easyccg_parser_on_json_sentences_questions.py questions \
	> data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.json
	
	python scripts/webquestions-preprocessing/training_split.py data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.json
	head -n200 data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.json > data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.json.train.200
	tail -n200 data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.json > data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.json.dev.200
	
	head -n100 data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.json > data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.json.train.100
	tail -n100 data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.json > data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.json.dev.100

# Paraphrased webquestions
parse_webquestions_easyccg_paraphrase:
	cat data/webquestions/webquestions.examples.test.domains.filtered.json \
	| python scripts/webquestions-preprocessing/tokenise.py \
	| python scripts/webquestions-preprocessing/tag_named_entities_normal.py data/webquestions/webquestions.examples.test.domains.manual.lexicon \
	| java -cp .:tools/stanford-ner-2012-11-11/stanford-ner.jar:tools/stanford-ner-2012-11-11/gson-2.2.2.jar:tools/stanford-ner-2012-11-11/guava-14.0.1.jar:scripts NerJsonInputData \
	| python scripts/cleaning/ner_post_process.py \
	| python scripts/webquestions-preprocessing/non_copulize.py \
	| python scripts/webquestions-preprocessing/paraphrase_rules.py \
	| python scripts/webquestions-preprocessing/run_candc_tagger_ner_on_json_sentences_questions.py questions \
	| python scripts/webquestions-preprocessing/run_easyccg_parser_on_json_sentences_questions.py questions \
	> data/webquestions/webquestions.examples.test.domains.easyccg.parse.filtered.paraphrase.json
	
	cat data/webquestions/webquestions.examples.train.domains.filtered.json \
	| python scripts/webquestions-preprocessing/tokenise.py \
	| python scripts/webquestions-preprocessing/tag_named_entities_normal.py data/webquestions/webquestions.examples.train.domains.manual.lexicon \
	| java -cp .:tools/stanford-ner-2012-11-11/stanford-ner.jar:tools/stanford-ner-2012-11-11/gson-2.2.2.jar:tools/stanford-ner-2012-11-11/guava-14.0.1.jar:scripts NerJsonInputData \
	| python scripts/cleaning/ner_post_process.py \
	| python scripts/webquestions-preprocessing/non_copulize.py \
	| python scripts/webquestions-preprocessing/paraphrase_rules.py \
	| python scripts/webquestions-preprocessing/run_candc_tagger_ner_on_json_sentences_questions.py questions \
	| python scripts/webquestions-preprocessing/run_easyccg_parser_on_json_sentences_questions.py questions \
	> data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.paraphrase.json
	
	python scripts/webquestions-preprocessing/training_split.py data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.paraphrase.json
	head -n200 data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.paraphrase.json.80 > data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.paraphrase.json.train.200  
	tail -n200 data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.paraphrase.json.80 > data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.paraphrase.json.dev.200
	
	head -n100 data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.paraphrase.json.80 > data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.paraphrase.json.train.100  
	tail -n100 data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.paraphrase.json.80 > data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.paraphrase.json.dev.100

# Main Experiments
#
# TACL MWG Baseline
tacl_mwg:
	mkdir -p working/tacl_mwg
	java -Xms2048m -cp lib/*:graph-parser.jar in.sivareddy.graphparser.cli.RunGraphToQueryTrainingMain \
	-schema data/freebase/schema/business_film_people_schema.txt \
	-relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	-lexicon data/tacl/grounded_lexicon/tacl_grounded_lexicon.txt \
	-cachedKB data/freebase/domain_facts/business_film_people_facts.txt.gz \
	-domain "http://business.freebase.com;http://film.freebase.com;http://people.freebase.com" \
	-nthreads 10 \
	-iterations 1 \
	-nBestTestSyntacticParses 1 \
	-nbestGraphs 100 \
	-useSchema true \
	-useKB true \
	-groundFreeVariables false \
	-useEmptyTypes false \
	-ignoreTypes true \
	-urelGrelFlag true \
	-urelPartGrelPartFlag false \
	-utypeGtypeFlag true \
	-wordGrelPartFlag false \
	-wordBigramGrelPartFlag true \
	-argGrelPartFlag true \
	-stemMatchingFlag true \
	-mediatorStemGrelPartMatchingFlag true \
	-argumentStemMatchingFlag true \
	-argumentStemGrelPartMatchingFlag true \
	-graphIsConnectedFlag false \
	-graphHasEdgeFlag true \
	-countNodesFlag false \
	-edgeNodeCountFlag false \
	-duplicateEdgesFlag true \
	-grelGrelFlag true \
	-useLexiconWeightsRel true \
	-useLexiconWeightsType false \
	-validQueryFlag false \
	-initialEdgeWeight 1.0 \
	-initialTypeWeight -1.0 \
	-initialWordWeight 1.0 \
	-stemFeaturesWeight 0.0 \
	-endpoint bravas \
	-devFile data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.json.dev.200 \
	-testFile data/tacl/webquestions.examples.test.domains.easyccg.parse.filtered.json \
	-logFile working/tacl_mwg/business_film_people.log.txt \
	> working/tacl_mwg/business_film_people.txt

tacl_mwg_on_training_data:
	mkdir -p working/tacl_mwg_on_training
	java -Xms2048m -cp lib/*:graph-parser.jar in.sivareddy.graphparser.cli.RunGraphToQueryTrainingMain \
	-schema data/freebase/schema/business_film_people_schema.txt \
	-relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	-lexicon data/tacl/grounded_lexicon/tacl_grounded_lexicon.txt \
	-cachedKB data/freebase/domain_facts/business_film_people_facts.txt.gz \
	-domain "http://business.freebase.com;http://film.freebase.com;http://people.freebase.com" \
	-nthreads 10 \
	-iterations 1 \
	-nBestTestSyntacticParses 1 \
	-nbestGraphs 100 \
	-useSchema true \
	-useKB true \
	-groundFreeVariables false \
	-useEmptyTypes false \
	-ignoreTypes true \
	-urelGrelFlag true \
	-urelPartGrelPartFlag false \
	-utypeGtypeFlag true \
	-wordGrelPartFlag false \
	-wordBigramGrelPartFlag true \
	-argGrelPartFlag true \
	-stemMatchingFlag true \
	-mediatorStemGrelPartMatchingFlag true \
	-argumentStemMatchingFlag true \
	-argumentStemGrelPartMatchingFlag true \
	-graphIsConnectedFlag false \
	-graphHasEdgeFlag true \
	-countNodesFlag false \
	-edgeNodeCountFlag false \
	-duplicateEdgesFlag true \
	-grelGrelFlag true \
	-useLexiconWeightsRel true \
	-useLexiconWeightsType false \
	-validQueryFlag false \
	-initialEdgeWeight 1.0 \
	-initialTypeWeight -1.0 \
	-initialWordWeight 1.0 \
	-stemFeaturesWeight 0.0 \
	-endpoint stkilda \
	-devFile data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.json.train.915 \
	-testFile data/tacl/webquestions.examples.test.domains.easyccg.parse.filtered.json \
	-logFile working/tacl_mwg_on_training/business_film_people.log.txt \
	> working/tacl_mwg_on_training/business_film_people.txt

tacl_mwg_free917:
	mkdir -p working/tacl_mwg_free917
	java -Xms2048m -cp lib/*:graph-parser.jar in.sivareddy.graphparser.cli.RunGraphToQueryTrainingMain \
	-schema data/freebase/schema/business_film_people_schema.txt \
	-relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	-lexicon data/tacl/grounded_lexicon/tacl_grounded_lexicon.txt \
	-cachedKB data/freebase/domain_facts/business_film_people_facts.txt.gz \
	-domain "http://business.freebase.com;http://film.freebase.com;http://people.freebase.com" \
	-nthreads 10 \
	-iterations 1 \
	-nBestTestSyntacticParses 1 \
	-nbestGraphs 100 \
	-useSchema true \
	-useKB true \
	-groundFreeVariables false \
	-useEmptyTypes false \
	-ignoreTypes true \
	-urelGrelFlag true \
	-urelPartGrelPartFlag false \
	-utypeGtypeFlag true \
	-wordGrelPartFlag false \
	-wordBigramGrelPartFlag true \
	-argGrelPartFlag true \
	-stemMatchingFlag true \
	-mediatorStemGrelPartMatchingFlag true \
	-argumentStemMatchingFlag true \
	-argumentStemGrelPartMatchingFlag true \
	-graphIsConnectedFlag false \
	-graphHasEdgeFlag true \
	-countNodesFlag false \
	-edgeNodeCountFlag false \
	-duplicateEdgesFlag true \
	-grelGrelFlag true \
	-useLexiconWeightsRel true \
	-useLexiconWeightsType false \
	-validQueryFlag false \
	-initialEdgeWeight 1.0 \
	-initialTypeWeight -1.0 \
	-initialWordWeight 1.0 \
	-stemFeaturesWeight 0.0 \
	-endpoint bravas \
	-devFile data/cai-yates-2013/question-and-logical-form-917/acl2014_domains/business_film_people_parse.txt \
	-logFile working/tacl_mwg_free917/business_film_people.log.txt \
	> working/tacl_mwg_free917/business_film_people.txt

tacl_mwg_merged:
	mkdir -p working/tacl_mwg_merged
	java -Xms2048m -cp lib/*:graph-parser.jar in.sivareddy.graphparser.cli.RunGraphToQueryTrainingMain \
	-schema data/freebase/schema/business_film_people_schema.txt \
	-relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	-lexicon data/tacl/grounded_lexicon/business_film_people_merged_tacl_grounded_lexicon.txt \
	-cachedKB data/freebase/domain_facts/business_film_people_facts.txt.gz \
	-domain "http://business.freebase.com;http://film.freebase.com;http://people.freebase.com" \
	-nthreads 10 \
	-trainingSampleSize 100 \
	-iterations 10 \
	-nBestTrainSyntacticParses 1 \
	-nBestTestSyntacticParses 1 \
	-nbestGraphs 100 \
	-useSchema true \
	-useKB true \
	-groundFreeVariables false \
	-useEmptyTypes false \
	-ignoreTypes true \
	-urelGrelFlag true \
	-urelPartGrelPartFlag false \
	-utypeGtypeFlag true \
	-wordGrelPartFlag false \
	-wordBigramGrelPartFlag true \
	-argGrelPartFlag true \
	-stemMatchingFlag true \
	-mediatorStemGrelPartMatchingFlag true \
	-argumentStemMatchingFlag true \
	-argumentStemGrelPartMatchingFlag true \
	-graphIsConnectedFlag false \
	-graphHasEdgeFlag true \
	-countNodesFlag false \
	-edgeNodeCountFlag false \
	-duplicateEdgesFlag true \
	-grelGrelFlag true \
	-useLexiconWeightsRel true \
	-useLexiconWeightsType false \
	-validQueryFlag false \
	-initialEdgeWeight 1.0 \
	-initialTypeWeight -1.0 \
	-initialWordWeight 1.0 \
	-stemFeaturesWeight 0.0 \
	-endpoint bravas \
	-devFile data/tacl/webquestions.examples.train.domains.easyccg.parse.filtered.json.dev.200 \
	-testFile data/tacl/webquestions.examples.test.domains.easyccg.parse.filtered.json \
	-logFile working/tacl_mwg_merged/business_film_people.log.txt \
	> working/tacl_mwg_merged/business_film_people.txt

# TACL GraphPaser results
tacl_unsupervised:
	mkdir -p ../working/tacl_unsupervised
	java -Xms2048m -cp lib/*:graph-parser.jar in.sivareddy.graphparser.cli.RunGraphToQueryTrainingMain \
	-schema data/freebase/schema/business_film_people_schema.txt \
	-relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	-lexicon data/tacl/grounded_lexicon/tacl_grounded_lexicon.txt \
	-cachedKB data/freebase/domain_facts/business_film_people_facts.txt.gz \
	-domain "http://business.freebase.com;http://film.freebase.com;http://people.freebase.com" \
	-nthreads 20 \
	-trainingSampleSize 500 \
	-iterations 80 \
	-nBestTrainSyntacticParses 1 \
	-nBestTestSyntacticParses 1 \
	-nbestGraphs 100 \
	-useSchema true \
	-useKB true \
	-groundFreeVariables true \
	-useEmptyTypes false \
	-ignoreTypes false \
	-urelGrelFlag true \
	-urelPartGrelPartFlag false \
	-utypeGtypeFlag true \
	-gtypeGrelFlag false \
	-wordGrelPartFlag false \
	-wordBigramGrelPartFlag false \
	-argGrelPartFlag false \
	-stemMatchingFlag true \
	-mediatorStemGrelPartMatchingFlag true \
	-argumentStemMatchingFlag true \
	-argumentStemGrelPartMatchingFlag true \
	-graphIsConnectedFlag false \
	-graphHasEdgeFlag true \
	-countNodesFlag false \
	-edgeNodeCountFlag false \
	-duplicateEdgesFlag true \
	-grelGrelFlag true \
	-useLexiconWeightsRel true \
	-useLexiconWeightsType true \
	-validQueryFlag true \
	-initialEdgeWeight 1.0 \
	-initialTypeWeight -2.0 \
	-initialWordWeight -0.05 \
	-stemFeaturesWeight 0.0 \
	-endpoint bravas \
	-trainingCorpora data/tacl/sentences_training/tacl_training_sentences.txt.gz \
	-devFile data/tacl/webquestions.examples.train.domains.easyccg.parse.filtered.json.dev.200 \
	-testFile data/tacl/webquestions.examples.test.domains.easyccg.parse.filtered.json \
	-logFile ../working/tacl_unsupervised/business_film_people.log.txt \
	> ../working/tacl_unsupervised/business_film_people.txt

tacl_unsupervised_loaded_model:
	mkdir -p ../working/tacl_unsupervised_loaded_model
	java -Xms2048m -cp lib/*:graph-parser.jar in.sivareddy.graphparser.cli.RunGraphToQueryTrainingMain \
	-schema data/freebase/schema/business_film_people_schema.txt \
	-relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	-lexicon data/tacl/grounded_lexicon/tacl_grounded_lexicon.txt \
	-cachedKB data/freebase/domain_facts/business_facts.txt.gz \
	-domain "http://business.freebase.com;http://film.freebase.com;http://people.freebase.com" \
	-nthreads 20 \
	-nBestTrainSyntacticParses 1 \
	-nBestTestSyntacticParses 10 \
	-nbestGraphs 100 \
	-useSchema true \
	-useKB true \
	-groundFreeVariables true \
	-useEmptyTypes false \
	-ignoreTypes false \
	-urelGrelFlag true \
	-urelPartGrelPartFlag false \
	-utypeGtypeFlag true \
	-gtypeGrelFlag false \
	-wordGrelPartFlag false \
	-wordBigramGrelPartFlag false \
	-argGrelPartFlag false \
	-stemMatchingFlag true \
	-mediatorStemGrelPartMatchingFlag true \
	-argumentStemMatchingFlag true \
	-argumentStemGrelPartMatchingFlag true \
	-graphIsConnectedFlag false \
	-graphHasEdgeFlag true \
	-countNodesFlag false \
	-edgeNodeCountFlag false \
	-duplicateEdgesFlag true \
	-grelGrelFlag true \
	-useLexiconWeightsRel true \
	-useLexiconWeightsType true \
	-validQueryFlag true \
	-initialEdgeWeight 1.0 \
	-initialTypeWeight -2.0 \
	-initialWordWeight -0.05 \
	-stemFeaturesWeight 0.0 \
	-endpoint bravas \
	-loadModelFromFile working/tacl_unsupervised/business_film_people.log.txt.model.bestIteration \
	-groundInputCorpora data/tacl/sentences_training/business_tacl_training_sentences_small.txt.gz \
	-logFile working/tacl_unsupervised_loaded_model/business_film_people.log.txt \
	> working/tacl_unsupervised_loaded_model/business_film_people.txt


# TACL GraphParser + Para results
tacl_unsupervised_paraphrase:
	mkdir -p working/tacl_unsupervised_paraphrase
	java -Xms2048m -cp .:GraphParser.jar in.sivareddy.graphparser.cli.RunGraphToQueryTrainingMain \
	-schema data/freebase/schema/business_film_people_schema.txt \
	-relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
	-lexicon data/freebase/grounded_lexicon/business_film_people_grounded_lexicon.txt \
	-cachedKB data/freebase/domain_facts/business_film_people_facts.txt.gz \
	-domain "http://business.freebase.com;http://film.freebase.com;http://people.freebase.com" \
	-nthreads 20 \
	-trainingSampleSize 600 \
	-iterations 20 \
	-nBestTrainSyntacticParses 1 \
	-nBestTestSyntacticParses 1 \
	-nbestGraphs 100 \
	-useSchema true \
	-useKB true \
	-groundFreeVariables true \
	-useEmptyTypes false \
	-ignoreTypes false \
	-urelGrelFlag true \
	-urelPartGrelPartFlag false \
	-utypeGtypeFlag true \
	-gtypeGrelFlag false \
	-wordGrelPartFlag false \
	-wordBigramGrelPartFlag false \
	-argGrelPartFlag false \
	-stemMatchingFlag true \
	-mediatorStemGrelPartMatchingFlag true \
	-argumentStemMatchingFlag true \
	-argumentStemGrelPartMatchingFlag true \
	-graphIsConnectedFlag false \
	-graphHasEdgeFlag true \
	-countNodesFlag false \
	-edgeNodeCountFlag false \
	-duplicateEdgesFlag true \
	-grelGrelFlag true \
	-useLexiconWeightsRel true \
	-useLexiconWeightsType true \
	-validQueryFlag true \
	-initialEdgeWeight 1.0 \
	-initialTypeWeight 1.0 \
	-initialWordWeight -0.05 \
	-stemFeaturesWeight 0.0 \
	-endpoint localhost \
	-trainingCorpora "data/freebase/sentences_training_filtered/business_training_sentences_filtered_00000.txt.gz;data/freebase/sentences_training_filtered/film_training_sentences_filtered_00000.txt.gz;data/freebase/sentences_training_filtered/people_training_sentences_filtered_00000.txt.gz" \
	-devFile data/webquestions/webquestions.examples.train.domains.easyccg.parse.filtered.paraphrase.json.dev.200 \
	-testFile data/webquestions/webquestions.examples.test.domains.easyccg.parse.filtered.paraphrase.json \
	-logFile working/tacl_unsupervised_paraphrase/business_film_people.log.txt \
	> working/tacl_unsupervised_paraphrase/business_film_people.txt

# Spanish Experiments

# Tokenize Entities
tokenize_spanish_entities:
	zcat data/freebase/spanish/spanish_business_entities.txt.gz | java -cp lib/*:bin others.SpanishEntityTokenizer | gzip > data/freebase/spanish/spanish_business_entities.tokenized.txt.gz
	zcat data/freebase/spanish/spanish_film_entities.txt.gz | java -cp lib/*:bin others.SpanishEntityTokenizer | gzip > data/freebase/spanish/spanish_film_entities.tokenized.txt.gz
	zcat data/freebase/spanish/spanish_people_entities.txt.gz | java -cp lib/*:bin others.SpanishEntityTokenizer | gzip > data/freebase/spanish/spanish_people_entities.tokenized.txt.gz
	zcat data/freebase/spanish/spanish_business_entities.tokenized.txt.gz data/freebase/spanish/spanish_film_entities.tokenized.txt.gz data/freebase/spanish/spanish_people_entities.tokenized.txt.gz | gzip > data/freebase/spanish/spanish_business_film_people_entities.tokenized.txt.gz

extract_spanish_sentences:
	bzcat data/bravas/extracted/AA/wiki_00.bz2 \
		| java -cp lib/*:bin others.SpanishTokenizer                 \
		| perl -pe 's|=LRB=.*?=RRB=||g'                 \
		| grep -v =LRB= | grep -v =RRB=                 \
		| python scripts/spanish/select_sentences_with_entities_in_relation.py data/freebase/spanish/spanish_business_film_people_entities.tokenized.txt.gz data/freebase/domain_facts/business_film_people_facts.txt.gz data/freebase/schema/business_film_people_schema.txt                 \
		| python scripts/spanish/select_sentences_with_non_adjacent_main_relation.py data/freebase/domain_facts/business_film_people_facts.txt.gz data/freebase/schema/business_film_people_schema.txt \
		| java -cp lib/*:bin others.SpanishPosAndNer \
		| python scripts/spanish/process_named_entities.py \
		| gzip > data/freebase/spanish/spanish_wikipedia_business_film_people_sentences.json.txt.gz

create_spanish_deplambda_format:
	zcat data/freebase/spanish/spanish_wikipedia_business_film_people_sentences.json.txt.gz \
		| python scripts/spanish/create-entity-mention-format.py \
		| gzip \
		> working/spanish_wikipedia.txt.gz

## Unsupervised Parsing experiments
unsupervised_first_experiment:
	mkdir -p working/unsupervised_first_experiment
	java -Xms2048m -cp lib/*:graph-parser.jar in.sivareddy.graphparser.cli.RunGraphToQueryTrainingMain \
    -schema data/freebase/schema/business_film_people_schema.txt \
    -relationTypesFile data/freebase/stats/business_film_people_relation_types.txt \
    -lexicon data/dummy.txt \
    -ccgLexicon data/dummy.txt \
    -ccgIndexedMapping lib_data/ybisk-mapping.txt \
    -unaryRules data/dummy.txt \
    -binaryRules data/dummy.txt \
    -cachedKB data/freebase/domain_facts/business_film_people_facts.txt.gz \
    -domain "http://business.freebase.com;http://film.freebase.com;http://people.freebase.com" \
    -nthreads 20 \
    -trainingSampleSize 600 \
    -iterations 10 \
    -nBestTrainSyntacticParses 100 \
    -nBestTestSyntacticParses 1 \
    -nbestGraphs 100 \
    -debugEnabledFlag false \
    -useSchema true \
    -useKB true \
    -groundFreeVariables true \
    -useEmptyTypes false \
    -ignoreTypes true \
    -urelGrelFlag true \
    -urelPartGrelPartFlag false \
    -utypeGtypeFlag false \
    -gtypeGrelFlag false \
    -wordGrelPartFlag false \
    -wordBigramGrelPartFlag false \
    -argGrelPartFlag false \
    -stemMatchingFlag true \
    -mediatorStemGrelPartMatchingFlag false \
    -argumentStemMatchingFlag false \
    -argumentStemGrelPartMatchingFlag false \
    -graphIsConnectedFlag true \
    -graphHasEdgeFlag true \
    -countNodesFlag true \
    -edgeNodeCountFlag true \
    -duplicateEdgesFlag true \
    -grelGrelFlag true \
    -useLexiconWeightsRel false \
    -useLexiconWeightsType false \
    -validQueryFlag true \
    -initialEdgeWeight 1.0 \
    -initialTypeWeight -1.0 \
    -initialWordWeight 10.00 \
    -stemFeaturesWeight 0.0 \
    -useNbestGraphsFlag true \
    -endpoint darkstar \
    -trainingCorpora "data/unsupervised/training/unsupervised_parser.json.noDeps.gz" \
    -logFile working/unsupervised_first_experiment/business_film_people.log.txt \
    > working/unsupervised_first_experiment/business_film_people.txt
