doc:
	echo "✅ swift-doc"
	swift-doc Sources --output Documentation
	echo "✅ swift-dcov"
	swift-dcov Sources > Documentation/dcov.json
	echo "✅ swift-api-inventory"
	swift-api-inventory Sources > Documentation/api.txt
	echo "✅ swift-api-diagram"
	swift-api-diagram Sources > Documentation/api.dot
	echo "✅ dot"
	dot -T pdf Documentation/api.dot > Documentation/api.pdf
