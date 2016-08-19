typedef Target = {
	protocol:String,
	host:String
}

typedef SupportedTarget = {
	>Target,
	name:String,
	providerName:String
}


