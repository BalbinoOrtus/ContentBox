/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * I model a ContentBox site for multi-site support
 */
component
	persistent="true"
	entityname="cbSite"
	table     ="cb_site"
	extends   ="contentbox.models.BaseEntity"
	cachename ="cbSite"
	cacheuse  ="read-write"
{

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	property
		name     ="siteId"
		fieldtype="id"
		generator="native"
		setter   ="false"
		params   ="{ allocationSize = 1, sequence = 'siteId_seq' }";

	property
		name   ="name"
		ormtype="string"
		notnull="true"
		length ="255"
		default="";

	property
		name   ="slug"
		ormtype="string"
		notnull="true"
		length ="255"
		unique ="true"
		default=""
		index  ="idx_siteSlug";

	property
		name   ="description"
		ormtype="string"
		notnull="false"
		default=""
		length ="500";

	property
		name   ="domainRegex"
		ormtype="string"
		notnull="false"
		default=""
		length ="255";

	/* *********************************************************************
	 **							PK + CONSTRAINTS
	 ********************************************************************* */

	this.pk = "siteId";

	this.constraints = {
		"name" : { required : true, size : "1..255" },
		"slug" : {
			required  : true,
			size      : "1..255",
			validator : "UniqueValidator@cborm"
		},
		"description" : { required : false, size : "1..500" },
		"domainRegex" : { required : true, size : "1..255" }
	};

	/* *********************************************************************
	 **							PUBLIC METHODS
	 ********************************************************************* */

	/**
	 * Constructor
	 */
	function init(){
		super.init();

		return this;
	}

	/**
	 * Get memento representation
	 * @excludes Property excludes
	 */
	function getMemento( excludes = "" ){
		var pList  = listToArray( "name,slug,description,domainRegex" );
		var result = getBaseMemento( properties = pList, excludes = arguments.excludes );

		return result;
	}

}
