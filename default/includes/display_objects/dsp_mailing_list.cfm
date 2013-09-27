<!---
	This file is part of Mura CMS.

	Mura CMS is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, Version 2 of the License.

	Mura CMS is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

	Linking Mura CMS statically or dynamically with other modules constitutes 
	the preparation of a derivative work based on Mura CMS. Thus, the terms 
	and conditions of the GNU General Public License version 2 ("GPL") cover 
	the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant 
	you permission to combine Mura CMS with programs or libraries that are 
	released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS 
	grant you permission to combine Mura CMS with independent software modules 
	(plugins, themes and bundles), and to distribute these plugins, themes and 
	bundles without Mura CMS under the license of your choice, provided that 
	you follow these specific guidelines: 

	Your custom code 

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories:

		/admin/
		/tasks/
		/config/
		/requirements/mura/
		/Application.cfc
		/index.cfm
		/MuraProxy.cfc

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that 
	meets the above guidelines as a combined work under the terms of GPL for 
	Mura CMS, provided that you include the source code of that other code when 
	and as the GNU GPL requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not 
	obligated to grant this special exception for your modified version; it is 
	your choice whether to do so, or to make such modified version available 
	under the GNU General Public License version 2 without this exception.  You 
	may, if you choose, apply this exception to your own modified versions of 
	Mura CMS.
--->
<cfsilent>
	<cfquery datasource="#application.configBean.getDatasource(mode='readOnly')#" username="#application.configBean.getDBUsername(mode='readOnly')#" password="#application.configBean.getDBPassword(mode='readOnly')#" name="variables.rslist">
		SELECT mlid, name, ispurge, description 
		FROM tmailinglist 
		WHERE siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.$.event('siteID')#">
			AND
				<cfif isValid('UUID',arguments.objectID)>
					mlid
				<cfelse>
					name
				</cfif>
				=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectid#">
	</cfquery>
</cfsilent>
<cfoutput>
	<div class="svMailingList well" id="#createCSSID(variables.rslist.name)#">
		
		<cfif variables.$.event('doaction') eq 'unsubscribe'>
			<cfif variables.$.event("passedProtect")>
				<p class="success">#variables.$.rbKey('mailinglist.youhaveunsubscribed')#</p>
			<cfelse>
				<p class="error">#variables.$.rbKey('captcha.spam')#</p>
			</cfif>
		<cfelseif variables.$.event('doaction') eq 'subscribe' and variables.rslist.isPurge neq 1>
			<cfif variables.$.event("passedProtect")>
				<p class="success">#variables.$.rbKey('mailinglist.youhavesubscribed')#</p>
			<cfelse>
				<p class="error">#variables.$.rbKey('captcha.spam')#</p>
			</cfif>
		<cfelseif variables.$.event('doaction') eq 'subscribe' and variables.rslist.isPurge eq 1>
			<cfif variables.$.event("passedProtect")>
				<p class="success">#variables.$.rbKey('mailinglist.emailremoved')#</p>
			<cfelse>
				<p class="error">#variables.$.rbKey('captcha.spam')#</p>
			</cfif>	
		<cfelse>

			<!--- THE FORM --->
			<form role="form" class="form-horizontal clearfix" name="frmMailingList" action="?nocache=1" method="post" onsubmit="return validate(this);" novalidate="novalidate" >
				<fieldset>
					<legend>#HTMLEditFormat(variables.rslist.name)#</legend>

					<!--- Form Description --->
					<cfif #variables.rslist.description# neq ''>
						<div class="description">#HTMLEditFormat(variables.rslist.description)#</div>
					</cfif>

					<cfif variables.rslist.isPurge neq 1>

						<!--- First Name --->
						<div class="req form-group">
							<label for="txtNameFirst" class="col-lg-2 control-label">
								#variables.$.rbKey('mailinglist.fname')# 
								<ins>(#variables.$.rbKey('mailinglist.required')#)</ins>
							</label>
							<div class="col-lg-10">
								<input type="text" id="txtNameFirst" class="text form-control" name="fname" maxlength="50" required="true" message="#HTMLEditFormat(variables.$.rbKey('mailinglist.fnamerequired'))#"/>
							</div>
						</div>

						<!--- Last Name --->
						<div class="req form-group">
							<label for="txtNameLast" class="col-lg-2 control-label">
								#variables.$.rbKey('mailinglist.lname')# 
								<ins>(#variables.$.rbKey('mailinglist.required')#)</ins>
							</label>
							<div class="col-lg-10">
								<input type="text" id="txtNameLast" class="text form-control" name="lname" maxlength="50" required="true" message="#HTMLEditFormat(variables.$.rbKey('mailinglist.lnamerequired'))#"/>
							</div>
						</div>

						<!--- Company --->
						<div class="form-group">
							<label for="txtCompany" class="col-lg-2 control-label">
								#variables.$.rbKey('mailinglist.company')#
							</label>
							<div class="col-lg-10">
								<input type="text" id="txtCompany" class="text form-control" name="company" maxlength="50" />
							</div>
						</div>
					</cfif>

					<!--- Email --->
					<div class="req form-group">
						<label for="txtEmail" class="col-lg-2 control-label">
							#variables.$.rbKey('mailinglist.email')# 
							<ins>(#variables.$.rbKey('mailinglist.required')#)</ins>
						</label>
						<div class="col-lg-10">
							<input type="text" id="txtEmail" class="text form-control" name="email" maxlength="50" required="true" validate="email" message="#HTMLEditFormat(variables.$.rbKey('mailinglist.emailvalidate'))#"/>
						</div>
					</div>
				</fieldset>

				<div class="buttons">
					<input type="hidden" name="linkServID" value="#variables.$.content('contentID')#" />
					<input type="hidden" name="mlid" value="#variables.rslist.mlid#">
					<input type="hidden" name="siteid" value="#variables.$.event('siteID')#" />

					<cfif variables.rslist.isPurge eq 0>
						<input type="hidden" name="doaction" value="subscribe" checked="checked" />
						<input type="hidden" name="isVerified" value="1" />
						<!--- Subscribe --->
						<div class="form-group">
							<div class="col-lg-offset-2 col-lg-10">
								<input type="submit" class="submit btn btn-default" value="#HTMLEditFormat(variables.$.rbKey('mailinglist.subscribe'))#" />
							</div>
						</div>
					<cfelse>
						<input type="hidden" name="doaction" value="subscribe"  />
						<input type="hidden" name="isVerified" value="1"  />
						<!--- Unsubscribe --->
						<div class="form-group">
							<div class="col-lg-offset-2 col-lg-10">
								<input type="submit" class="submit btn btn-default" value="#HTMLEditFormat(variables.$.rbKey('mailinglist.unsubscribe'))#" />
							</div>
						</div>
					</cfif>
					
					#variables.$.dspObject_Include(thefile='dsp_form_protect.cfm')#
				</div>
			</form>
		</cfif>
	</div>
</cfoutput>