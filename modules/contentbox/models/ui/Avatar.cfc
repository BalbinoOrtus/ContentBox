﻿/*
 * An avatar model object for ContentBox
 */
component singleton {

	// DI
	property name="requestService" inject="coldbox:requestService";
	property name="requestStorage" inject="requestStorage@cbStorages";

	/**
	 * Constructor
	 */
	function init(){
		return this;
	}

	/**
	 * Render an avatar image
	 *
	 * @email The email to render
	 * @size The pixel size, defaults to 80
	 * @class An optional class to add to the img tag produced
	 */
	function renderAvatar(
		required email,
		numeric size = 80,
		string class = "gravatar"
	){
		// check settings
		var prc = variables.requestService.getContext().getPrivateCollection();
		if ( NOT prc.cbSettings.cb_gravatar_display ) {
			return "";
		}
		// Build out avatar
		return variables.requestStorage.getOrSet( "avatar-#hash( arguments.toString() )#", function(){
			// render it out
			savecontent variable="local.avatar" {
				writeOutput(
					"
					<img 	class=""#class#""
							align=""middle""
							width=""#size#""
							height=""#size#""
							src=""//www.gravatar.com/avatar.php?gravatar_id=#lCase( hash( email ) )#&s=#size#&r=#prc.cbSettings.cb_gravatar_rating#"" />"
				);
			}
			return local.avatar;
		} );
	}

}
