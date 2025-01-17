﻿/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A mapped super class used for contentbox content: entries and pages
 */
component
	persistent         ="true"
	entityname         ="cbContent"
	table              ="cb_content"
	extends            ="contentbox.models.BaseEntityMethods"
	cachename          ="cbContent"
	cacheuse           ="read-write"
	discriminatorColumn="contentType"
{

	/* *********************************************************************
	 **							DI INJECTIONS
	 ********************************************************************* */

	property
		name      ="wirebox"
		inject    ="wirebox"
		persistent="false";

	property
		name      ="cachebox"
		inject    ="cachebox"
		persistent="false";

	property
		name      ="settingService"
		inject    ="id:settingService@cb"
		persistent="false";

	property
		name      ="interceptorService"
		inject    ="coldbox:interceptorService"
		persistent="false";

	property
		name      ="customFieldService"
		inject    ="customFieldService@cb"
		persistent="false";

	property
		name      ="categoryService"
		inject    ="categoryService@cb"
		persistent="false";

	property
		name      ="contentService"
		inject    ="contentService@cb"
		persistent="false";

	property
		name      ="contentVersionService"
		inject    ="contentVersionService@cb"
		persistent="false";

	property
		name      ="i18n"
		inject    ="i18n@cbi18n"
		persistent="false";

	/* *********************************************************************
	 **							NON PERSISTED PROPERTIES
	 ********************************************************************* */

	property
		name      ="renderedContent"
		persistent="false"
		default   ="";

	/* *********************************************************************
	 **							STUPID PROPERTIES DUE TO ACF BUG
	 ********************************************************************* */

	property
		name   ="createdDate"
		type   ="date"
		ormtype="timestamp"
		notnull="true"
		update ="false";

	property
		name   ="modifiedDate"
		type   ="date"
		ormtype="timestamp"
		notnull="true";

	property
		name     ="isDeleted"
		ormtype  ="boolean"
		// sqltype  = "smallInt"
		notnull  ="true"
		default  ="false"
		dbdefault="false";

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	property
		name     ="contentID"
		notnull  ="true"
		fieldtype="id"
		generator="native"
		setter   ="false"
		params   ="{ allocationSize = 1, sequence = 'contentID_seq' }";

	property
		name   ="contentType"
		setter ="false"
		update ="false"
		insert ="false"
		index  ="idx_discriminator,idx_published"
		default="";

	property
		name   ="title"
		notnull="true"
		length ="200"
		default=""
		index  ="idx_search";

	property
		name   ="slug"
		notnull="true"
		length ="200"
		default=""
		index  ="idx_slug,idx_publishedSlug";

	property
		name   ="publishedDate"
		notnull="false"
		ormtype="timestamp"
		index  ="idx_publishedDate";

	property
		name   ="expireDate"
		notnull="false"
		ormtype="timestamp"
		default=""
		index  ="idx_expireDate";

	property
		name     ="isPublished"
		notnull  ="true"
		ormtype  ="boolean"
		// sqltype  = "smallInt"
		dbdefault="true"
		default  ="true"
		index    ="idx_published,idx_search,idx_publishedSlug";

	property
		name     ="allowComments"
		notnull  ="true"
		ormtype  ="boolean"
		// sqltype  = "smallInt"
		default  ="true"
		dbdefault="true";

	property
		name   ="passwordProtection"
		notnull="false"
		length ="100"
		default=""
		index  ="idx_published";

	property
		name   ="HTMLKeywords"
		notnull="false"
		length ="160"
		default="";

	property
		name   ="HTMLDescription"
		notnull="false"
		length ="160"
		default="";

	property
		name   ="HTMLTitle"
		notnull="false"
		length ="255"
		default="";

	property
		name     ="cache"
		notnull  ="true"
		ormtype  ="boolean"
		// sqltype  = "smallInt"
		default  ="true"
		dbdefault="true"
		index    ="idx_cache";

	property
		name     ="cacheLayout"
		notnull  ="true"
		ormtype  ="boolean"
		// sqltype  = "smallInt"
		default  ="true"
		dbdefault="true"
		index    ="idx_cachelayout";

	property
		name   ="cacheTimeout"
		notnull="false"
		ormtype="integer"
		default="0"
		index  ="idx_cachetimeout";

	property
		name   ="cacheLastAccessTimeout"
		notnull="false"
		ormtype="integer"
		default="0"
		index  ="idx_cachelastaccesstimeout";

	property
		name   ="markup"
		notnull="true"
		length ="100"
		default="HTML";

	property
		name     ="showInSearch"
		notnull  ="true"
		ormtype  ="boolean"
		// sqltype  = "smallInt"
		default  ="true"
		dbdefault="true"
		index    ="idx_showInSearch";

	property
		name   ="featuredImage"
		notnull="false"
		default=""
		length ="255";

	property
		name   ="featuredImageURL"
		notnull="false"
		default=""
		length ="255";

	/* *********************************************************************
	 **							RELATIONSHIPS
	 ********************************************************************* */

	// M20 -> creator loaded as a proxy and fetched immediately
	property
		name     ="creator"
		notnull  ="true"
		cfc      ="contentbox.models.security.Author"
		fieldtype="many-to-one"
		fkcolumn ="FK_authorID"
		lazy     ="true"
		fetch    ="join";

	// M20 -> site loaded as a proxy and fetched immediately
	property
		name     ="site"
		notnull  ="true"
		cfc      ="contentbox.models.system.Site"
		fieldtype="many-to-one"
		fkcolumn ="FK_siteId"
		lazy     ="true"
		fetch    ="join";

	// O2M -> Comments
	property
		name        ="comments"
		singularName="comment"
		fieldtype   ="one-to-many"
		type        ="array"
		lazy        ="extra"
		batchsize   ="25"
		orderby     ="createdDate"
		cfc         ="contentbox.models.comments.Comment"
		fkcolumn    ="FK_contentID"
		inverse     ="true"
		cascade     ="all-delete-orphan";

	// O2M -> CustomFields
	property
		name        ="customFields"
		singularName="customField"
		fieldtype   ="one-to-many"
		type        ="array"
		lazy        ="extra"
		batchsize   ="25"
		cfc         ="contentbox.models.content.CustomField"
		fkcolumn    ="FK_contentID"
		inverse     ="true"
		cascade     ="all-delete-orphan";

	// O2M -> ContentVersions
	property
		name        ="contentVersions"
		singularName="contentVersion"
		fieldtype   ="one-to-many"
		type        ="array"
		lazy        ="extra"
		batchsize   ="25"
		cfc         ="contentbox.models.content.ContentVersion"
		orderby     ="version desc"
		fkcolumn    ="FK_contentID"
		inverse     ="true"
		cascade     ="all-delete-orphan";

	// M20 -> Parent Page loaded as a proxy
	property
		name     ="parent"
		cfc      ="contentbox.models.content.BaseContent"
		fieldtype="many-to-one"
		fkcolumn ="FK_parentID"
		lazy     ="true";

	// O2M -> Sub Content Inverse
	property
		name        ="children"
		singularName="child"
		fieldtype   ="one-to-many"
		type        ="array"
		lazy        ="extra"
		batchsize   ="25"
		orderby     ="createdDate"
		cfc         ="contentbox.models.content.BaseContent"
		fkcolumn    ="FK_parentID"
		inverse     ="true"
		cascade     ="all-delete-orphan";

	// O2M -> Comment Subscribers
	property
		name        ="commentSubscriptions"
		singularName="commentSubscription"
		fieldtype   ="one-to-many"
		type        ="array"
		lazy        ="extra"
		batchsize   ="25"
		cfc         ="contentbox.models.subscriptions.CommentSubscription"
		fkcolumn    ="FK_contentID"
		inverse     ="true"
		cascade     ="all-delete-orphan";

	// M2M -> Categories
	property
		name             ="categories"
		fieldtype        ="many-to-many"
		type             ="array"
		lazy             ="extra"
		orderby          ="category"
		cascade          ="save-update"
		cfc              ="contentbox.models.content.Category"
		fkcolumn         ="FK_contentID"
		linktable        ="cb_contentCategories"
		inversejoincolumn="FK_categoryID";

	// M2M -> Related Content - Content related from this content to other content
	property
		name             ="relatedContent"
		fieldtype        ="many-to-many"
		type             ="array"
		lazy             ="extra"
		orderby          ="title"
		cascade          ="save-update"
		cfc              ="contentbox.models.content.BaseContent"
		fkcolumn         ="FK_contentID"
		linktable        ="cb_relatedContent"
		inversejoincolumn="FK_relatedContentID";

	// M2M -> Linked Content - Content related to this content from other content
	property
		name             ="linkedContent"
		fieldtype        ="many-to-many"
		type             ="array"
		lazy             ="extra"
		cascade          ="save-update"
		inverse          ="true"
		orderby          ="title"
		cfc              ="contentbox.models.content.BaseContent"
		fkcolumn         ="FK_relatedContentID"
		linktable        ="cb_relatedContent"
		inversejoincolumn="FK_contentID";

	// O2O -> Content Stats
	property
		name     ="stats"
		notnull  ="true"
		cfc      ="contentbox.models.content.Stats"
		fieldtype="one-to-one"
		mappedBy ="relatedContent"
		cascade  ="all-delete-orphan"
		lazy     ="true"
		fetch    ="join";

	/* *********************************************************************
	 **							CALCULATED FIELDS
	 ********************************************************************* */

	property
		name   ="numberOfHits"
		formula="select cbStats.hits
			from cb_stats cbStats
			where cbStats.FK_contentID=contentID"
		default="0";

	property
		name   ="numberOfChildren"
		formula="select count(*) from cb_content content where content.FK_parentID=contentID"
		default="0";

	property
		name   ="numberOfComments"
		formula="select count(*) from cb_comment comment where comment.FK_contentID=contentID"
		default="0";

	/* *********************************************************************
	 **							PK + CONSTRAINTS + STATIC VARS
	 ********************************************************************* */

	this.pk = "contentID";

	this.constraints = {
		"title"                  : { required : true, size : "1..200" },
		"slug"                   : { required : true, size : "1..200" },
		"publishedDate"          : { required : false, type : "date" },
		"expireDate"             : { required : false, type : "date" },
		"passwordProtection"     : { required : false, size : "1..100" },
		"HTMLKeywords"           : { required : false, size : "1..160" },
		"HTMLDescription"        : { required : false, size : "1..160" },
		"cacheTimeout"           : { required : false, type : "numeric" },
		"cacheLastAccessTimeout" : { required : false, type : "numeric" },
		"markup"                 : { required : true, size : "1..100" },
		"featuredImage"          : { required : false, size : "1..255" },
		"featuredImageURL"       : { required : false, size : "1..255" },
		"site"                   : { required : true }
	};

	// Used for JS controls
	variables.TIME_FORMAT         = "hh:mm tt";
	// Used for JS Controls
	variables.DATE_FORMAT         = "yyyy-mm-dd";
	// Used for display purposes
	variables.DATE_DISPLAY_FORMAT = "dd mmm yyyy";

	/* *********************************************************************
	 **							PUBLIC FUNCTIONS
	 ********************************************************************* */

	/**
	 * Base constructor
	 */
	function init(){
		variables.isPublished            = true;
		variables.allowComments          = true;
		variables.cache                  = true;
		variables.cacheLayout            = true;
		variables.cacheTimeout           = 0;
		variables.cacheLastAccessTimeout = 0;
		variables.markup                 = "HTML";
		variables.contentType            = "";
		variables.showInSearch           = true;
		variables.renderedContent        = "";

		super.init();

		return this;
	}

	/**
	 * Get the number of hits
	 */
	numeric function getNumberOfHits(){
		return ( isNull( variables.numberOfHits ) ? 0 : variables.numberOfHits );
	}

	/**
	 * Get the number of children
	 */
	numeric function getNumberOfChildren(){
		return ( isNull( variables.numberOfChildren ) ? 0 : variables.numberOfChildren );
	}

	/**
	 * Get the total number of comments this content object has
	 */
	numeric function getNumberOfComments(){
		return ( isNull( variables.numberOfComments ) ? 0 : variables.numberOfComments );
	}

	/**
	 * Get the total number of approved comments this content object has
	 */
	numeric function getNumberOfApprovedComments(){
		if ( !isLoaded() ) {
			return 0;
		}
		return variables.comments
			.filter( function( comment ){
				return comment.getIsApproved();
			} )
			.len();
	}

	/**
	 * Get the total number of versions this content object has
	 */
	numeric function getNumberOfVersions(){
		return (
			isLoaded() ? variables.contentVersionService.getNumberOfVersions( getContentId() ) : 0
		);
	}

	/**
	 * Get the total number of active versions this content object has
	 */
	numeric function getNumberOfActiveVersions(){
		return (
			isLoaded() ? variables.contentVersionService.getNumberOfVersions( getContentId(), true ) : 0
		);
	}

	/**
	 * Add a new content version to save for this content object
	 *
	 * @content The incoming content
	 * @changelog The changelog commit
	 * @author The author object
	 *
	 * @return BaseContent
	 */
	BaseContent function addNewContentVersion(
		required content,
		changelog = "",
		required author
	){
		// lock it for new content creation
		lock
			name          ="contentbox.addNewContentVersion.#getSlug()#"
			type          ="exclusive"
			timeout       ="10"
			throwOnTimeout=true {
			// get a new version object
			var newVersion= contentVersionService.new(
				properties = {
					content   : arguments.content,
					changelog : arguments.changelog
				}
			);

			// join them to author and related content
			newVersion.setAuthor( arguments.author );
			newVersion.setRelatedContent( this );

			// Do we already have an active version?
			if ( hasActiveContent() ) {
				// deactive the curent version
				var activeVersion = getActiveContent();
				activeVersion.setIsActive( false );
				// cap checks
				maxContentVersionChecks();
			}

			// Get the latest content version, to increase the new version number, collection is ordered by 'version' descending
			if ( hasContentVersion() ) {
				newVersion.setVersion( variables.contentVersions[ 1 ].getVersion() + 1 );
			}

			// Activate the new version
			newVersion.setIsActive( true );
			// Add it to the content so it can be saved as part of this content object
			addContentVersion( newVersion );
		}
		return this;
	}

	/**
	 * Returns a list of active related content for this piece of content
	 */
	string function getRelatedContentIDs(){
		var relatedContentIDs = "";
		// if we have related content...
		if ( hasRelatedContent() ) {
			// loop over related content and add ids to list
			for ( var currentContent in getRelatedContent() ) {
				relatedContentIDs = listAppend( relatedContentIDs, currentContent.getContentID() );
			}
		}
		return relatedContentIDs;
	}

	/**
	 * Override the setRelatedContent
	 *
	 * @relatedContent The related content to set
	 */
	BaseContent function setRelatedContent( required array relatedContent ){
		if ( hasRelatedContent() ) {
			variables.relatedContent.clear();
			variables.relatedContent.addAll( arguments.relatedContent );
		} else {
			variables.relatedContent = arguments.relatedContent;
		}
		return this;
	}

	/**
	 * Inflates from comma-delimited list (or array) of id's
	 * @relatedContent The list or array of relatedContent ids
	 */
	BaseContent function inflateRelatedContent( required any relatedContent ){
		var allContent = [];
		// convert to array
		if ( isSimpleValue( arguments.relatedContent ) ) {
			arguments.relatedContent = listToArray( arguments.relatedContent );
		}
		// iterate over array
		for ( var x = 1; x <= arrayLen( arguments.relatedContent ); x++ ) {
			var id            = trim( arguments.relatedContent[ x ] );
			// get content from id
			var extantContent = contentService.get( id );
			// if found, add to array
			if ( !isNull( extantContent ) ) {
				// append to array all new relatedContent
				arrayAppend( allContent, extantContent );
			}
		}
		setRelatedContent( allContent );
		return this;
	}

	/**
	 * Override the setComments
	 */
	BaseContent function setComments( required array comments ){
		if ( hasComment() ) {
			variables.comments.clear();
			variables.comments.addAll( arguments.comments );
		} else {
			variables.comments = arguments.comments;
		}
		return this;
	}

	/**
	 * Override the setCustomFields
	 */
	BaseContent function setCustomFields( required array customFields ){
		if ( hasCustomField() ) {
			variables.customFields.clear();
			variables.customFields.addAll( arguments.customFields );
		} else {
			variables.customFields = arguments.customFields;
		}
		return this;
	}

	/**
	 * Get custom fields as a structure representation
	 */
	struct function getCustomFieldsAsStruct(){
		var results = {};

		// if no fields, just return empty
		if ( !hasCustomField() ) {
			return results;
		}

		// iterate and create
		for ( var thisField in variables.customFields ) {
			results[ thisField.getKey() ] = thisField.getValue();
		}

		return results;
	}

	/**
	 * Shortcut to get a custom field value
	 * @key The custom field key to get
	 * @defaultValue The default value if the key is not found.
	 */
	any function getCustomField( required key, defaultValue ){
		var fields = getCustomFieldsAsStruct();
		if ( structKeyExists( fields, arguments.key ) ) {
			return fields[ arguments.key ];
		}
		if ( structKeyExists( arguments, "defaultValue" ) ) {
			return arguments.defaultValue;
		}
		throw(
			message = "No custom field with key: #arguments.key# found",
			detail  = "The keys are #structKeyList( fields )#",
			type    = "InvalidCustomField"
		);
	}

	/**
	 * Override the setContentVersions
	 */
	BaseContent function setContentVersions( required array contentVersions ){
		if ( hasContentVersion() ) {
			variables.contentVersions.clear();
			variables.contentVersions.addAll( arguments.contentVersions );
		} else {
			variables.contentVersions = arguments.contentVersions;
		}
		return this;
	}

	/**
	 * Only adds it if not found in content object
	 */
	BaseContent function addCategories( required category ){
		if ( !hasCategories( arguments.category ) ) {
			arrayAppend( variables.categories, arguments.category );
		}
		return this;
	}

	/**
	 * Remove only if it's found in the content object
	 */
	BaseContent function removeCategories( required category ){
		if ( hasCategories( arguments.category ) ) {
			arrayDelete( variables.categories, arguments.category );
		}
		return this;
	}

	/*
	 * I remove all category associations
	 */
	BaseContent function removeAllCategories(){
		if ( hasCategories() ) {
			variables.categories.clear();
		} else {
			variables.categories = [];
		}
		return this;
	}

	/*
	 * I remove all linked content associations
	 */
	BaseContent function removeAllLinkedContent(){
		if ( hasLinkedContent() ) {
			for ( var item in variables.linkedContent ) {
				item.removeRelatedContent( this );
			}
		}
		return this;
	}

	/**
	 * Override the setChildren
	 */
	BaseContent function setChildren( required array children ){
		if ( hasChild() ) {
			variables.children.clear();
			variables.children.addAll( arguments.children );
		} else {
			variables.children = arguments.children;
		}
		return this;
	}

	/**
	 * Get a flat representation of this entry but for UI response format which
	 * restricts the data being generated.
	 * @slugCache Cache of slugs to prevent infinite recursions
	 * @showComments Show comments in memento or not
	 * @showCustomFields Show comments in memento or not
	 * @showParent Show parent in memento or not
	 * @showChildren Show children in memento or not
	 * @showCategories Show categories in memento or not
	 * @showRelatedContent Show related Content in memento or not
	 * @excludes Excludes
	 * @properties Additional properties to incorporate in the memento
	 */
	struct function getResponseMemento(
		required array slugCache   = [],
		boolean showAuthor         = true,
		boolean showComments       = true,
		boolean showCustomFields   = true,
		boolean showParent         = true,
		boolean showChildren       = true,
		boolean showCategories     = true,
		boolean showRelatedContent = true,
		excludes                   = "",
		array properties
	){
		var pList = [
			"title",
			"slug",
			"allowComments",
			"HTMLKeywords",
			"HTMLDescription",
			"HTMLTitle",
			"featuredImageURL",
			"contentType"
		];
		// Add incoming properties
		if ( structKeyExists( arguments, "properties" ) ) {
			pList.addAll( arguments.properties );
		}
		var result = getBaseMemento( properties = pList, excludes = arguments.excludes );

		// Properties
		result[ "content" ]       = renderContent();
		result[ "createdDate" ]   = getDisplayCreatedDate();
		result[ "publishedDate" ] = getDisplayPublishedDate();
		result[ "expireDate" ]    = getDisplayExpireDate();

		// Comments
		if ( arguments.showComments && hasComment() ) {
			result[ "comments" ] = [];
			for ( var thisComment in variables.comments ) {
				arrayAppend(
					result[ "comments" ],
					{
						"content"     : thisComment.getContent(),
						"createdDate" : thisComment.getDisplayCreatedDate(),
						"authorURL"   : thisComment.getAuthorURL(),
						"author"      : thisComment.getAuthor()
					}
				);
			}
		} else if ( arguments.showComments ) {
			result[ "comments" ] = [];
		}

		// Custom Fields
		if ( arguments.showCustomFields && hasCustomField() ) {
			result[ "customfields" ] = getCustomFieldsAsStruct();
		} else if ( arguments.showCustomFields ) {
			result[ "customfields" ] = [];
		}

		// Parent
		if ( arguments.showParent && hasParent() ) {
			result[ "parent" ] = {
				"slug"        : getParent().getSlug(),
				"title"       : getParent().getTitle(),
				"contentType" : getParent().getContentType()
			};
		}
		// Children
		if ( arguments.showChildren && hasChild() ) {
			result[ "children" ] = [];
			for ( var thisChild in variables.children ) {
				arrayAppend(
					result[ "children" ],
					{
						"slug"  : thisChild.getSlug(),
						"title" : thisChild.getTitle()
					}
				);
			}
		} else if ( arguments.showChildren ) {
			result[ "children" ] = [];
		}
		// Categories
		if ( arguments.showCategories && hasCategories() ) {
			result[ "categories" ] = [];
			for ( var thisCategory in variables.categories ) {
				arrayAppend(
					result[ "categories" ],
					{
						"category" : thisCategory.getCategory(),
						"slug"     : thisCategory.getSlug()
					}
				);
			}
		} else if ( arguments.showCategories ) {
			result[ "categories" ] = [];
		}

		// Related Content
		if (
			arguments.showRelatedContent && hasRelatedContent() && !arrayFindNoCase(
				arguments.slugCache,
				getSlug()
			)
		) {
			result[ "relatedcontent" ] = [];
			// add slug to cache
			arrayAppend( arguments.slugCache, getSlug() );
			for ( var content in variables.relatedContent ) {
				arrayAppend(
					result[ "relatedcontent" ],
					{
						"slug"        : content.getSlug(),
						"title"       : content.getTitle(),
						"contentType" : content.getContentType()
					}
				);
			}
		} else if ( arguments.showRelatedContent ) {
			result[ "relatedcontent" ] = [];
		}

		return result;
	}

	/**
	 * Get a flat representation of this entry
	 * @slugCache Cache of slugs to prevent infinite recursions
	 * @counter
	 * @showAuthor Show author in memento or not
	 * @showComments Show comments in memento or not
	 * @showCustomFields Show comments in memento or not
	 * @showContentVersions Show content versions in memento or not
	 * @showParent Show parent in memento or not
	 * @showChildren Show children in memento or not
	 * @showCategories Show categories in memento or not
	 * @showRelatedContent Show related Content in memento or not
	 * @showStats Show stats in memento or not
	 * @showCommentSubscriptions Show comment subscriptions or not
	 * @excludes Excludes
	 * @properties Additional properties to incorporate in the memento
	 */
	function getMemento(
		required array slugCache         = [],
		counter                          = 0,
		boolean showAuthor               = true,
		boolean showComments             = true,
		boolean showCustomFields         = true,
		boolean showContentVersions      = true,
		boolean showParent               = true,
		boolean showChildren             = true,
		boolean showCategories           = true,
		boolean showRelatedContent       = true,
		boolean showStats                = true,
		boolean showCommentSubscriptions = true,
		excludes                         = "activeContent,linkedContent,commentSubscriptions",
		array properties
	){
		// Do this to convert native Array to CF Array for content properties
		var pList = listToArray( arrayToList( contentService.getPropertyNames() ) );
		// Add incoming properties
		if ( structKeyExists( arguments, "properties" ) ) {
			pList.addAll( arguments.properties );
		}
		var result = getBaseMemento( properties = pList, excludes = arguments.excludes );

		// Do Author Relationship
		if ( arguments.showAuthor && hasCreator() ) {
			result[ "creator" ] = {
				"creatorID" : getCreator().getAuthorID(),
				"firstname" : getCreator().getFirstname(),
				"lastName"  : getCreator().getLastName(),
				"email"     : getCreator().getEmail(),
				"username"  : getCreator().getUsername()
			};
		}

		// Comments
		if ( arguments.showComments && hasComment() ) {
			result[ "comments" ] = [];
			for ( var thisComment in variables.comments ) {
				arrayAppend( result[ "comments" ], thisComment.getMemento() );
			}
		} else if ( arguments.showComments ) {
			result[ "comments" ] = [];
		}

		// Stats
		if ( arguments.showStats && hasStats() ) {
			result[ "stats" ] = getStats().getMemento();
		} else if ( arguments.showStats ) {
			result[ "stats" ] = { "statsID" : 0, "hits" : 0 };
		}

		// Custom Fields
		if ( arguments.showCustomFields && hasCustomField() ) {
			result[ "customfields" ] = [];
			for ( var thisField in variables.customfields ) {
				arrayAppend( result[ "customfields" ], thisField.getMemento() );
			}
		} else if ( arguments.showCustomFields ) {
			result[ "customfields" ] = [];
		}
		// Versions
		if ( arguments.showContentVersions && hasContentVersion() ) {
			result[ "contentversions" ] = [];
			for ( var thisVersion in variables.contentversions ) {
				arrayAppend( result[ "contentversions" ], thisVersion.getMemento() );
			}
		} else if ( arguments.showContentVersions ) {
			result[ "contentversions" ] = [];
		}
		// Parent
		if ( arguments.showParent && hasParent() ) {
			result[ "parent" ] = {
				"contentID" : getParent().getContentID(),
				"slug"      : getParent().getSlug(),
				"title"     : getParent().getTitle()
			};
		}
		// Children
		if ( arguments.showChildren && hasChild() ) {
			result[ "children" ] = [];
			for ( var thisChild in variables.children ) {
				arrayAppend( result[ "children" ], thisChild.getMemento() );
			}
		} else if ( arguments.showChildren ) {
			result[ "children" ] = [];
		}
		// Comment Subscriptions
		if ( arguments.showCommentSubscriptions && hasCommentSubscription() ) {
			result[ "commentSubscriptions" ] = [];
			for ( var thisChild in variables.commentSubscriptions ) {
				arrayAppend( result[ "commentSubscriptions" ], thisChild.getMemento() );
			}
		} else if ( arguments.showCommentSubscriptions ) {
			result[ "commentSubscriptions" ] = [];
		}
		// Categories
		if ( arguments.showCategories && hasCategories() ) {
			result[ "categories" ] = [];
			for ( var thisCategory in variables.categories ) {
				arrayAppend( result[ "categories" ], thisCategory.getMemento() );
			}
		} else if ( arguments.showCategories ) {
			result[ "categories" ] = [];
		}

		// Related Content
		if (
			arguments.showRelatedContent && hasRelatedContent() && !arrayFindNoCase(
				arguments.slugCache,
				getSlug()
			)
		) {
			result[ "relatedcontent" ] = [];
			// add slug to cache
			arrayAppend( arguments.slugCache, getSlug() );
			for ( var content in variables.relatedContent ) {
				arrayAppend(
					result[ "relatedcontent" ],
					content.getMemento( slugCache = arguments.slugCache )
				);
			}
		} else if ( arguments.showRelatedContent ) {
			result[ "relatedcontent" ] = [];
		}

		// Site Snapshot
		result[ "site" ] = {};
		if ( hasSite() ) {
			result.site[ "siteId" ] = getSite().getSiteId();
			result.site[ "name" ]   = getSite().getName();
			result.site[ "slug" ]   = getSite().getSlug();
		}

		return result;
	}

	/**
	 * Verify and rotate maximum content versions
	 */
	private function maxContentVersionChecks(){
		if ( !len( settingService.getSetting( "cb_versions_max_history" ) ) ) {
			return;
		}

		// How many versions do we have?
		var versionCounts = contentVersionService
			.newCriteria()
			.isEq( "relatedContent.contentID", getContentID() )
			.count();

		// Have we passed the limit?
		if ( ( versionCounts + 1 ) GT settingService.getSetting( "cb_versions_max_history" ) ) {
			var oldestVersion = contentVersionService
				.newCriteria()
				.isEq( "relatedContent.contentID", getContentID() )
				.isEq( "isActive", javacast( "boolean", false ) )
				.withProjections( id = "true" )
				.list(
					sortOrder = "createdDate DESC",
					offset    = settingService.getSetting( "cb_versions_max_history" ) - 2
				);
			// delete by primary key IDs found
			contentVersionService.deleteByID( arrayToList( oldestVersion ) );
		}
	}

	/**
	 * Retrieves the latest content string from the latest version un-translated
	 */
	string function getContent(){
		return getActiveContent().getContent();
	}

	/**
	 * Get the latest active content object, empty new one if none assigned
	 */
	ContentVersion function getActiveContent(){
		// If not loaded, return a new entity
		if ( !isLoaded() ) {
			return variables.contentVersionService.new();
		}
		// Load up the active content
		if ( isNull( variables.activeContent ) ) {
			// Iterate and find, they are sorted descending, so it should be quick, unless we don't have one and that's ok.
			for ( var thisVersion in variables.contentVersions ) {
				if ( thisVersion.getIsActive() ) {
					variables.activeContent = thisVersion;
					break;
				}
			}
			// We didn't find one, something is out of sync
			if ( isNull( variables.activeContent ) ) {
				return variables.contentVersionService.new();
			}
		}
		return variables.activeContent;
	}

	/**
	 * Verify if this content object has an active version with content
	 */
	boolean function hasActiveContent(){
		// If we are not persisted, then no exit out.
		if ( !isLoaded() ) {
			return false;
		}
		// Iterate and find, they are sorted descending, so it should be quick, unless we don't have one and that's ok.
		for ( var thisVersion in variables.contentVersions ) {
			if ( thisVersion.getIsActive() ) {
				return true;
			}
		}
		return false;
	}

	/**
	 * Shorthand Creator name
	 */
	string function getCreatorName(){
		if ( hasCreator() ) {
			return getCreator().getName();
		}
		return "";
	}

	/**
	 * Shorthand Creator email
	 */
	string function getCreatorEmail(){
		if ( hasCreator() ) {
			return getCreator().getEmail();
		}
		return "";
	}

	/**
	 * Shorthand Author name from latest version
	 */
	string function getAuthorName(){
		return getActiveContent().getAuthorName();
	}

	/**
	 * Shorthand Author email from latest version
	 */
	string function getAuthorEmail(){
		return getActiveContent().getAuthorEmail();
	}

	/**
	 * Shorthand Author from latest version or null if any yet
	 */
	any function getAuthor(){
		return getActiveContent().getAuthor();
	}

	/************************************** PUBLIC *********************************************/

	/**
	 * Get parent ID if set or empty if none
	 *
	 * @return The parent ID or empty value if none attached
	 */
	function getParentID(){
		return ( hasParent() ? getParent().getContentID() : "" );
	}

	/**
	 * Get parent name or empty if none
	 *
	 * @return The parent name or empty value if none attached
	 */
	function getParentName(){
		return ( hasParent() ? getParent().getTitle() : "" );
	}

	/**
	 * Bit that denotes if the content has expired or not, in order to be expired the content must have been published as well
	 */
	boolean function isExpired(){
		return ( isContentPublished() AND !isNull( expireDate ) AND expireDate lte now() ) ? true : false;
	}

	/**
	 * Bit that denotes if the content has been published or not
	 */
	boolean function isContentPublished(){
		return ( getIsPublished() AND !isNull( publishedDate ) AND getPublishedDate() LTE now() ) ? true : false;
	}

	/**
	 * Bit that denotes if the content has been published or not in the future
	 */
	boolean function isPublishedInFuture(){
		return ( getIsPublished() AND getPublishedDate() GT now() ) ? true : false;
	}

	/**
	 * Is entity loaded
	 */
	boolean function isLoaded(){
		return ( len( getContentID() ) ? true : false );
	}

	/**
	 * Prepare a content object for cloning. This processes several things:
	 *
	 * - Wipe primary key, and descendant keys
	 * - Prepare for cloning of entire hierarchies
	 * - Make sure categories are cloned
	 *
	 * @author The author doing the cloning
	 * @original The original content object that will be cloned into this content object
	 * @originalService The ContentBox content service object
	 * @publish Publish pages or leave as drafts
	 * @originalSlugRoot The original slug that will be replaced in all cloned content
	 * @newSlugRoot The new slug root that will be replaced in all cloned content
	 */
	BaseContent function prepareForClone(
		required any author,
		required any original,
		required any originalService,
		required boolean publish,
		required any originalSlugRoot,
		required any newSlugRoot
	){
		// Base Content Property cloning
		variables.isPublished            = arguments.publish;
		variables.createdDate            = now();
		variables.modifiedDate           = variables.createdDate;
		variables.HTMLKeywords           = arguments.original.getHTMLKeywords();
		variables.HTMLDescription        = arguments.original.getHTMLDescription();
		variables.HTMLTitle              = arguments.original.getHTMLTitle();
		variables.markup                 = arguments.original.getMarkup();
		variables.cache                  = arguments.original.getCache();
		variables.cacheLayout            = arguments.original.getCacheLayout();
		variables.cacheTimeout           = arguments.original.getCacheTimeout();
		variables.cacheLastAccessTimeout = arguments.original.getCacheLastAccessTimeout();
		variables.showInSearch           = arguments.original.getShowInSearch();
		variables.featuredImage          = arguments.original.getFeaturedImage();
		variables.featuredImageURL       = arguments.original.getFeaturedImageURL();
		// remove all comments
		variables.comments               = [];
		// Are we publishing?
		if ( arguments.publish ) {
			variables.publishedDate = now();
		}
		// get latest content versioning
		var latestContent = arguments.original.getActiveContent().getContent();
		// Original slug updates on all content
		latestContent     = reReplaceNoCase(
			latestContent,
			"page\:\[#arguments.originalSlugRoot#\/",
			"page:[#arguments.newSlugRoot#/",
			"all"
		);

		// reset versioning, and start with a new one
		addNewContentVersion(
			content  : latestContent,
			changelog: "Content Cloned!",
			author   : arguments.author
		);

		// safe clone custom fields
		variables.customFields = arguments.original
			.getCustomFields()
			.map( function( thisField ){
				return variables.customFieldService
					.new( {
						key   : arguments.thisField.getKey(),
						value : arguments.thisField.getValue()
					} )
					.setRelatedContent( this );
			} );

		// clone related content
		arguments.original
			.getRelatedContent()
			.each( function( thisRelatedContent ){
				addRelatedContent( arguments.thisRelatedContent );
			} );

		// clone categories
		arguments.original
			.getCategories()
			.each( function( thisCategory ){
				addCategories(
					variables.categoryService.getOrCreate( arguments.thisCategory, getSite() )
				);
			} );

		// now clone children
		if ( arguments.original.hasChild() ) {
			arguments.original
				.getChildren()
				.each( function( thisChild ){
					// Preapre new Child
					var newChild = originalService
						.new( {
							parent  : this,
							creator : author,
							title   : arguments.thisChild.getTitle(),
							slug    : this.getSlug() & "/" & listLast(
								arguments.thisChild.getSlug(),
								"/"
							),
							site : getSite()
						} )
						// now deep clone until no more child is left behind.
						.prepareForClone(
							author           = author,
							original         = arguments.thisChild,
							originalService  = originalService,
							publish          = publish,
							originalSlugRoot = originalSlugRoot,
							newSlugRoot      = newSlugRoot
						);

					// now attach it to this piece of content
					addChild( newChild );
				} );
		}

		// evict original entity from hibernate cache, just in case
		variables.contentService.evict( arguments.original );

		return this;
	}

	/**
	 * Get display publishedDate
	 * @showTime Show time on return string or not
	 */
	string function getPublishedDateForEditor( boolean showTime = false ){
		var pDate = getPublishedDate();
		if ( isNull( pDate ) ) {
			pDate = now();
		}
		// get formatted date
		var fDate = dateFormat( pDate, variables.DATE_FORMAT );
		if ( arguments.showTime ) {
			fDate &= " " & timeFormat( pDate, variables.TIME_FORMAT );
		}
		return fDate;
	}

	/**
	 * Get display expireDate
	 * @showTime Show time on return string or not
	 */
	string function getExpireDateForEditor( boolean showTime = false ){
		var pDate = getExpireDate();
		if ( isNull( pDate ) ) {
			pDate = "";
		}
		// get formatted date
		var fDate = dateFormat( pDate, variables.DATE_FORMAT );
		if ( arguments.showTime ) {
			fDate &= " " & timeFormat( pDate, variables.TIME_FORMAT );
		}
		return fDate;
	}

	/**
	 * Get display publishedDate
	 */
	string function getDisplayPublishedDate(){
		var publishedDate = getPublishedDate();
		if ( isNull( publishedDate ) ) {
			return "";
		}
		return dateFormat( publishedDate, variables.DATE_DISPLAY_FORMAT ) & " " & timeFormat(
			publishedDate,
			variables.TIME_FORMAT
		);
	}

	/**
	 * Get formatted expireDate
	 */
	string function getDisplayExpireDate(){
		if ( isNull( expireDate ) ) {
			return "N/A";
		}
		return dateFormat( expireDate, variables.DATE_DISPLAY_FORMAT ) & " " & timeFormat(
			expireDate,
			variables.TIME_FORMAT
		);
	}

	/**
	 * isPassword Protected
	 */
	boolean function isPasswordProtected(){
		return len( getPasswordProtection() );
	}

	/**
	 * add published timestamp to property
	 */
	any function addPublishedTime( required hour, required minute ){
		if ( !isDate( getPublishedDate() ) ) {
			return this;
		}
		var time = timeFormat( "#arguments.hour#:#arguments.minute#", variables.TIME_FORMAT );
		setPublishedDate( getPublishedDate() & " " & time );
		return this;
	}

	/**
	 * add published timestamp to property
	 * @timeString The joined time string (e.g., 12:00)
	 */
	any function addJoinedPublishedTime( required string timeString ){
		var splitTime = listToArray( arguments.timeString, ":" );
		if ( arrayLen( splitTime ) == 2 ) {
			return addPublishedTime( splitTime[ 1 ], splitTime[ 2 ] );
		} else {
			return this;
		}
	}

	/**
	 * add expired timestamp to property
	 */
	any function addExpiredTime( required hour, required minute ){
		if ( !isDate( getExpireDate() ) ) {
			return this;
		}
		// verify time and minute defaults, else default to midnight
		if ( !len( arguments.hour ) ) {
			arguments.hour = "0";
		}
		if ( !len( arguments.minute ) ) {
			arguments.minute = "00";
		}
		// setup the right time now.
		var time = timeFormat( "#arguments.hour#:#arguments.minute#", variables.TIME_FORMAT );
		setExpireDate( getExpireDate() & " " & time );
		return this;
	}

	/**
	 * add expired timestamp to property
	 * @timeString The joined time string (e.g., 12:00)
	 */
	any function addJoinedExpiredTime( required string timeString ){
		var splitTime = listToArray( arguments.timeString, ":" );
		if ( arrayLen( splitTime ) == 2 ) {
			return addExpiredTime( splitTime[ 1 ], splitTime[ 2 ] );
		} else {
			return this;
		}
	}

	/**
	 * Build content cache keys according to sent content object
	 */
	string function buildContentCacheKey(){
		var inputHash = hash( cgi.server_name & cgi.query_string );
		return "cb-content-#getContentType()#-#getContentID()#-#i18n.getfwLocale()#-#inputHash#";
	}

	/**
	 * Verify we can do content caching on this content object using global and local rules
	 */
	boolean function canCacheContent(){
		var settings = settingService.getAllSettings();

		// check global caching first
		if (
			( getContentType() eq "page" AND settings.cb_content_caching ) OR
			( getContentType() eq "entry" AND settings.cb_entry_caching )
		) {
			// check override?
			return ( getCache() ? true : false );
		}
		return false;
	}

	/**
	 * Render content out using translations, caching, etc.
	 */
	any function renderContent() profile{
		var settings = settingService.getAllSettings();

		// caching enabled?
		if ( canCacheContent() ) {
			// Build Cache Key
			var cacheKey      = buildContentCacheKey();
			// Get appropriate cache provider
			var cache         = cacheBox.getCache( settings.cb_content_cacheName );
			// Try to get content?
			var cachedContent = cache.get( cacheKey );
			// Verify it exists, if it does, return it
			if ( !isNull( cachedContent ) AND len( cachedContent ) ) {
				return cachedContent;
			}
		}

		// Check if we need to translate
		if ( NOT len( variables.renderedContent ) ) {
			lock
				name          ="contentbox.contentrendering.#getContentID()#"
				type          ="exclusive"
				throwontimeout="true"
				timeout       ="10" {
				if ( NOT len( variables.renderedContent ) ) {
					// save content
					variables.renderedContent = renderContentSilent();
				}
			}
		}

		// caching enabled?
		if ( canCacheContent() ) {
			// Store content in cache, of local timeouts are 0 then use global timeouts.
			cache.set(
				cacheKey,
				variables.renderedContent,
				( getCacheTimeout() eq 0 ? settings.cb_content_cachingTimeout : getCacheTimeout() ),
				(
					getCacheLastAccessTimeout() eq 0 ? settings.cb_content_cachingTimeoutIdle : getCacheLastAccessTimeout()
				)
			);
		}

		// renturn translated content
		return variables.renderedContent;
	}

	/**
	 * Renders the content silently so no caching, or extra fluff is done, just content translation rendering.
	 * @content The content markup to translate, by default it uses the active content version's content
	 */
	any function renderContentSilent( any content = getContent() ) profile{
		// render content out, prepare builder
		var b = createObject( "java", "java.lang.StringBuilder" ).init( arguments.content );

		// announce renderings with data, so content renderers can process them
		var iData = { builder : b, content : this };
		interceptorService.announce( "cb_onContentRendering", iData );

		// return processed content
		return b.toString();
	}

	/**
	 * Inflate custom fields from the incoming count and memento structure
	 */
	any function inflateCustomFields( required numeric fieldCount, required struct memento ){
		// remove original custom fields
		getCustomFields().clear();

		// inflate custom fields start at 0 as it is incoming javascript counting of arrays
		for ( var x = 0; x lt arguments.fieldCount; x++ ) {
			// get custom field from incoming data
			var args = {
				key   : arguments.memento[ "CustomFieldKeys_#x#" ],
				value : arguments.memento[ "CustomFieldValues_#x#" ]
			};
			// only add if key has value
			if ( len( trim( args.key ) ) ) {
				var thisField = customFieldService.new( properties = args );
				thisField.setRelatedContent( this );
				addCustomField( thisField );
			}
		}

		return this;
	}

	/**
	 * Get a list string of the categories this content object has.
	 *
	 * @return The category list or `Uncategorized` if it doesn't have any
	 */
	function getCategoriesList(){
		if ( NOT hasCategories() ) {
			return "Uncategorized";
		}
		return arrayMap( variables.categories, function( item ){
			return item.getCategory();
		} ).toList();
	}

	/**
	 * Shortcut to get the site name
	 */
	function getSiteName(){
		return getSite().getName();
	}

	/**
	 * Shortcut to get the site slug
	 */
	function getSiteSlug(){
		return getSite().getSlug();
	}

	/**
	 * Shortcut to get the site id
	 */
	function getSiteId(){
		return getSite().getSiteId();
	}

	/**
	 * Verifies that the incoming site is the same as the content has already
	 *
	 * @site The site id or site object to verify
	 */
	boolean function isSameSite( required site ){
		// If no site attached, break.
		if ( !hasSite() ) {
			return false;
		}

		// Simple Value Test
		if ( isSimpleValue( arguments.site ) ) {
			return arguments.site == getSiteid();
		}

		// Object test
		return getSiteId() == arguments.site.getSiteId();
	}

}
