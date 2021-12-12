<?php
/**
 * @author Christoph Wurst <christoph@owncloud.com>
 * @author Joas Schilling <coding@schilljs.com>
 * @author Lukas Reschke <lukas@statuscode.ch>
 * @author Semih Serhat Karakaya <karakayasemi@itu.edu.tr>
 * @author Thomas Müller <thomas.mueller@tmit.eu>
 *
 * @copyright Copyright (c) 2018, ownCloud GmbH
 * @license AGPL-3.0
 *
 * This code is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License, version 3,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License, version 3,
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 *
 */

namespace OC\Core\Controller;

use OC\AppFramework\Http;
use OC\User\Session;
use \OCP\IL10N;
use \OCP\Mail\IMailer;
use OC_App;
use OC_Util;
use OCP\AppFramework\Controller;
use OCP\AppFramework\Http\RedirectResponse;
use OCP\AppFramework\Http\TemplateResponse;
use OCP\AppFramework\Http\DataResponse;
use OCP\License\ILicenseManager;
use OCP\IConfig;
use OCP\IRequest;
use OCP\ISession;
use OCP\IURLGenerator;
use OCP\IUser;
use OCP\IUserManager;
use Symfony\Component\EventDispatcher\EventDispatcherInterface;
use Symfony\Component\EventDispatcher\GenericEvent;


class RegisterController extends Controller {

	/** @var IUserManager */
	private $userManager;
	/** @var IL10N */
	private $l10n;
	/** @var IMailer */
	private $mailer;

	/** @var IConfig */
	private $config;

	/** @var ISession */
	private $session;

	/** @var Session */
	private $userSession;

	/** @var IURLGenerator */
	private $urlGenerator;

	/** @var ILicenseManager */
	private $licenseManager;

	/**
	 * @param string $appName
	 * @param IRequest $request
	 * @param IUserManager $userManager
	 * @param IConfig $config
	 * @param ISession $session
	 * @param Session $userSession
	 * @param IURLGenerator $urlGenerator
	 */
	public function __construct(
		$appName,
		IRequest $request,
		IUserManager $userManager,
		IConfig $config,
		ISession $session,
		Session $userSession,
		IL10N $l10n,
		IMailer $mailer,
		IURLGenerator $urlGenerator,
		ILicenseManager $licenseManager
	) {
		parent::__construct($appName, $request);
		$this->userManager = $userManager;
		$this->config = $config;
		$this->session = $session;
		$this->userSession = $userSession;
		$this->mailer = $mailer;
		$this->l10n = $l10n;
		$this->urlGenerator = $urlGenerator;
		$this->licenseManager = $licenseManager;
	}

	/**
	 * @PublicPage
	 * @NoCSRFRequired
	 * @UseSession
	 *
	 * @param string $user
	 * @param string $redirect_url
	 * @param string $remember_login
	 *
	 * @return TemplateResponse|RedirectResponse
	 */
	public function showRegisterForm($username, $redirect_url) {

		$parameters = [];
		$registerMessages = $this->session->get('registerMessages');
		$errors = [];
		$messages = [];
		if (\is_array($registerMessages)) {
			list($errors, $messages) = $registerMessages;
		}
		$this->session->remove('registerMessages');
		foreach ($errors as $value) {
			$parameters[$value] = true;
		}

		$parameters['messages'] = $messages;
		if ($username !== null && $username !== '') {
			$parameters['registerName'] = $username;
			$parameters['user_autofocus'] = false;
		} else {
			$parameters['registerName'] = '';
			$parameters['user_autofocus'] = true;
		}
		if (!empty($redirect_url)) {
			$parameters['redirect_url'] = $redirect_url;
		}

		if (!empty($redirect_url) &&
			(\strpos(
				$this->urlGenerator->getAbsoluteURL(\urldecode($redirect_url)),
				$this->urlGenerator->getAbsoluteURL('/index.php/f/')
			) !== false)) {
			$parameters['accessLink'] = true;
	}

	$licenseMessageInfo = $this->licenseManager->getLicenseMessageFor('core');
		// show license message only if there is a license
	$licenseState = $licenseMessageInfo['license_state'];
	if ($licenseState !== ILicenseManager::LICENSE_STATE_MISSING) {
			// license type === 1 implies it's a demo license
		if ($licenseMessageInfo['type'] === 1 ||
			($licenseState !== ILicenseManager::LICENSE_STATE_VALID &&
				$licenseState !== ILicenseManager::LICENSE_STATE_ABOUT_TO_EXPIRE)
		) {
			$parameters['licenseMessage'] = \implode('<br/>', $licenseMessageInfo['translated_message']);
	}
}


return new TemplateResponse(
	$this->appName,
	'register',
	$parameters,
	'guest'
);
}

	/**
	 * @PublicPage
	 * @UseSession
	 *
	 * @param string $user
	 * @param string $password
	 * @param string $redirect_url
	 * @param string $timezone
	 * @return RedirectResponse
	 * @throws \OCP\PreConditionNotMetException
	 * @throws \OC\User\LoginException
	 */
	public function tryRegister($username, $password, $redirect_url) {

		$args = [];
		$regexPassword = '/^(?=.*[0-9])(?=.*[A-Z]).{8,}$/';
		if (!empty($redirect_url)) {
			$args['redirect_url'] = $redirect_url;
		} 
		'@phan-var \OC\User\Manager $this->userManager';
		if ($this->userManager->userExists($username)) {
			$this->session->set('registerMessages',[ ['userExists'], []]);
			return new RedirectResponse($this->urlGenerator->linkToRoute('core.register.showRegisterForm', $args));
		}

		try {
			if (($password !== '') && ($username !== '')) {
				if(preg_match($regexPassword, $password)){
					$user = $this->userManager->createUser($username, $password);
				}
				else {
					$this->session->set('registerMessages',[ ['invalidpassword'], []]);
					return new RedirectResponse($this->urlGenerator->linkToRoute('core.register.showRegisterForm', $args));
				}
			}

		} catch (\Exception $exception) {
			$message = $exception->getMessage();
			if (!$message) {
				$message = $this->l10n->t('Unable to create user.');
			}
			$this->session->set('registerMessages',[ ['unable'], []]);
			return new RedirectResponse($this->urlGenerator->linkToRoute('core.register.showRegisterForm', $args));
		}

		$this->session->set('registerMessages',[ ['created'], []]);
		return new RedirectResponse($this->urlGenerator->linkToRoute('core.register.showRegisterForm', $args));
	}

}
