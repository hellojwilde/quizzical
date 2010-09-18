{* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is Quizzical.
 *
 * The Initial Developer of the Original Code is Jonathan Wilde.
 * Portions created by the Initial Developer are Copyright (C) 2009 - 2010
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** *}

{extends "../layout.tpl"}

{block "content"}
<div class="grid_9">
	<h2>Account</h2>
</div>

<div class="clear"></div>

<form method="post" action="{$current_url}">
	<div class="grid_6">
		<h3>Profile</h3>
		{validation_errors('<div class="error">', '</div>')}
		
		{if allowed_to('view', 'user_name', $user)}
			{if allowed_to('edit', 'user_name', $user)}
			<label>Name</label>
			<input type="text" class="text" name="name"
				   value="{$user->username|form_prep}" />
			<br />
			{else}
			<label>Name</label>
			<div class="field-text">{$user->username}</div>
			<span class="extra">
				You are not allowed to change the Name field; if you need it to
				be changed, please contact an administrator.
			</span>
			{/if}
		{/if}
		
		{if allowed_to('view', 'user_email', $user)}
			{if allowed_to('edit', 'user_email', $user)}
			<label>Email</label>
			<input type="text" class="text" name="email"
				   value="{$user->email|form_prep}" />
			<br />
			{else}
			<label>Email</label>
			<div class="field-text">{$user->email}</div>
			<span class="extra">
				You are not allowed to change the Email field.  If you need the
				email address to be changed, please contact an administrator.
			</span>
			{/if}
		{/if}

		{if allowed_to('view', 'user_ip', $user)}
		<label>Location</label>
		<div class="field-text">
			{$user->ip_address}
			&mdash;
			<a href="http://ws.arin.net/whois/?queryinput={$user->ip_address}">
				Details
			</a>
		</div>
		<br />
		{/if}

		{if allowed_to('view', 'user_group', $user)}
			{if allowed_to('edit', 'user_group', $user)}
			<label>Group</label>
			<select name="group">
				{foreach $groups group}
				<option value="{$group->id}"
					{tif $group->id == $user->group_id ? 'selected="selected"'}
					>{$group->name|capitalize}</option>
				{/foreach}
			</select>
			{else}
			<label>Group</label>
			<div class="field-text">{$user->group|capitalize}</div>
			<span class="extra">
				You are not allowed to edit the Group field for this user
				account.  If you need to modify this, please contact an
				administrator.
			</span>
			{/if}
		{/if}
	</div>
	
	
	<div class="grid_6">
		{if allowed_to('edit', 'user_password', $user)}
		<h3>Password</h3>
		
		<label>Current</label>
		<input type="password" class="text" name="old" />
		<br />
		
		<label>New</label>
		<input type="password" class="text" name="old" />
		<br />
		
		<label>New (Again)</label>
		<input type="password" class="text" name="old" />
		<br />
		{/if}
	</div>
	
	<div class="clear">&nbsp;</div>
	
	<div class="grid_9">
		{if allowed_to('edit', 'user', $user)}
		<input type="submit" class="button" value="Save Changes" />
		{/if}
	</div>
	
	{if allowed_to('delete', 'user', $user)}
	<div class="grid_3">
		<a href="{$site_url}/account/delete/{$user->id}" class="delete account">
			Delete Account</a>
	</div>
	{/if}
	
	<div class="clear">&nbsp;</div>
</form>
{/block}
