<?php /** @var $l \OCP\IL10N */ ?>
<?php
vendor_script('jsTimezoneDetect/jstz');
script('core', [
	'visitortimezone',
	'lostpassword',
	'login',
	'browser-update'
]);
?>

<!--[if IE 8]><style>input[type="checkbox"]{padding:0;}</style><![endif]-->
<form method="post" name="register" autocapitalize="none">
<?php if (!empty($_['accessLink'])) {
	?>
			<p class="warning">
				<?php p($l->t("You are trying to access a private link. Please log in first.")) ?>
			</p>
		<?php
} ?>
	<?php if (!empty($_['redirect_url'])) {
		print_unescaped('<input type="hidden" name="redirect_url" value="' . \OCP\Util::sanitizeHTML($_['redirect_url']) . '">');
	} ?>
		<?php if (isset($_['apacheauthfailed']) && ($_['apacheauthfailed'])): ?>
			<div class="warning">
				<?php p($l->t('Server side authentication failed!')); ?><br>
				<small><?php p($l->t('Please contact your administrator.')); ?></small>
			</div>
		<?php endif; ?>
		<?php foreach ($_['messages'] as $message): ?>
			<div class="warning">
				<?php p($message); ?><br>
			</div>
		<?php endforeach; ?>
		<?php if (isset($_['internalexception']) && ($_['internalexception'])): ?>
			<div class="warning">
				<?php p($l->t('An internal error occurred.')); ?><br>
				<small><?php p($l->t('Please try again or contact your administrator.')); ?></small>
			</div>
		<?php endif; ?>
		<div id="message" class="hidden">
			<img class="float-spinner" alt=""
				src="<?php p(image_path('core', 'loading-dark.gif'));?>">
			<span id="messageText"></span>
			<!-- the following div ensures that the spinner is always inside the #message div -->
			<div style="clear: both;"></div>
		</div>
		<?php if (isset($_['licenseMessage'])): ?>
			<div class="warning">
				<?php print_unescaped($_['licenseMessage']); ?>
			</div>
		<?php endif; ?>
		<div class="grouptop<?php if (!empty($_['invalidpassword'])) {
		echo ' shake';
	} ?>">
			<label for="username" class=""><?php p($l->t('Username')); ?></label>
			
			<input type="text" name="username" id="username"
				value="<?php p($_['registerName']); ?>"
				<?php p($_['user_autofocus'] ? 'autofocus' : ''); ?>
				placeholder="<?php p($l->t('UserName')); ?>"
				autocomplete="on" autocorrect="off" required>

		<div class="groupbottom<?php if (!empty($_['invalidpassword'])) {
		echo ' shake';
	} ?>">
			<label for="password" class=""><?php p($l->t('Password')); ?></label>
			
			<input type="password" name="password" id="password" value=""
				<?php p($_['user_autofocus'] ? '' : 'autofocus'); ?>
				aria-label="<?php p($l->t('Password')); ?>"
				placeholder="<?php p($l->t('Password')); ?>"
				autocomplete="off" autocorrect="off" required>
		</div>
		
		<div class="submit-wrap">
				
			<button type="submit" id="submit" class="login-button">
				<span><?php p($l->t('Register')); ?></span>
				<div class="loading-spinner"><div></div><div></div><div></div><div></div></div>
			</button>
		</div>
		<input type="hidden" name="timezone-offset" id="timezone-offset"/>
		<input type="hidden" name="timezone" id="timezone"/>
		<input type="hidden" name="requesttoken" value="<?php p($_['requesttoken']) ?>">

</form>
