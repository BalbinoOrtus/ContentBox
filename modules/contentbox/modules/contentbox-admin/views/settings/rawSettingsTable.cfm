<cfoutput>
<!--- settings --->
<table name="settings" id="settings" class="table table-striped table-hover " width="100%">
	<thead>
		<tr>
			<th width="280">Name</th>
			<th>Value</th>
			<th width="80">Site</th>
			<th class="text-center" width="80">Core</th>
			<th width="80" class="text-center {sorter:false}">Actions</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.settings#" index="setting">
		<tr>
			<td>
				<a 	href="javascript:edit(
					'#setting.getSettingId()#',
					'#HTMLEditFormat( setting.getName() )#',
					'#HTMLEditFormat( JSStringFormat( setting.getValue() ) )#',
					#setting.getIsCore()# )"
					title="Edit Setting">#setting.getName()#</a>
			</td>
			<td>
				<cfif len( setting.getValue() ) gt 90 >
					#html.textarea(
						value 	= setting.getValue(),
						rows 	= "5",
						class 	= "form-control",
						disabled = "true"
					)#
				<cfelse>
					#encodeForHTML( setting.getValue() )#
				</cfif>
			</td>
			<td>
				<cfif setting.hasSite()>
					#setting.getSite().getSlug()#
				<cfelse>
					---
				</cfif>
			</td>
			<td class="text-center">
				<cfif setting.getIsCore()>
					<i class="far fa-dot-circle text-success" title="Core Setting"></i>
				<cfelse>
					<i class="far fa-dot-circle text-danger"></i>
				</cfif>
			</td>
			<td class="text-center">
				<div class="btn-group btn-group-sm">

					<!--- Edit Command --->
					<a 	class="btn btn-sm btn-primary"
						href="javascript:edit(
							'#setting.getSettingId()#',
							'#encodeForHTMLAttribute( setting.getName() )#',
							'#encodeForHTMLAttribute( JSStringFormat( setting.getValue() ) )#',
							#setting.getIsCore() ? 'true' : 'false'#
						)"
						title="Edit Setting">
						<i class="far fa-keyboard fa-lg"></i>
					</a>

					<!--- Delete Command --->
					<cfif setting.getIsCore()>
						<a 	class="btn btn-sm btn-danger"
						disabled="disabled"
					<cfelse>
						<a 	class="btn btn-sm btn-danger confirmIt"
						href="javascript:remove( '#setting.getsettingID()#' )"
						title="Delete Setting"
					</cfif>
						data-title="<i class='far fa-trash-alt'></i> Delete Setting?">
							<i class="far fa-trash-alt fa-lg" id="delete_#setting.getsettingID()#"></i>
						</a>
				</div>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
<cfif !rc.viewAll>
	#prc.oPaging.renderit(
		foundRows 	= prc.settingsCount,
		link 		= prc.pagingLink,
		asList 		= true
	)#
</cfif>
</cfoutput>
