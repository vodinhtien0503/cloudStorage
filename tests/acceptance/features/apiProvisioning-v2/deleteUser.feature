@api @provisioning_api-app-required @skipOnLDAP
Feature: delete users
  As an admin
  I want to be able to delete users
  So that I can remove user from ownCloud

  Background:
    Given using OCS API version "2"

  @smokeTest
  Scenario: Delete a user
    Given user "brand-new-user" has been created with default attributes and without skeleton files
    When the administrator deletes user "brand-new-user" using the provisioning API
    Then the OCS status code should be "200"
    And the HTTP status code should be "200"
    And user "brand-new-user" should not exist

  @skipOnOcV10.3
  Scenario: Delete a user with special characters in the username
    Given these users have been created without skeleton files:
      | username | email               |
      | a@-+_.b  | a.b@example.com     |
      | a space  | a.space@example.com |
    When the administrator deletes the following users using the provisioning API
      | username |
      | a@-+_.b  |
      | a space  |
    Then the OCS status code of responses on all endpoints should be "200"
    And the HTTP status code of responses on all endpoints should be "200"
    And the following users should not exist
      | username |
      | a@-+_.b  |
      | a space  |

  Scenario: Delete a user, and specify the user name in different case
    Given user "brand-new-user" has been created with default attributes and without skeleton files
    When the administrator deletes user "Brand-New-User" using the provisioning API
    Then the OCS status code should be "200"
    And the HTTP status code should be "200"
    And user "brand-new-user" should not exist

  @smokeTest @notToImplementOnOCIS
  Scenario: subadmin deletes a user in their group
    Given these users have been created with default attributes and without skeleton files:
      | username       |
      | subadmin       |
      | brand-new-user |
    And group "new-group" has been created
    And user "brand-new-user" has been added to group "new-group"
    And user "subadmin" has been made a subadmin of group "new-group"
    When user "subadmin" deletes user "brand-new-user" using the provisioning API
    Then the OCS status code should be "200"
    And the HTTP status code should be "200"
    And user "brand-new-user" should not exist

  @issue-31276 @skipOnOcV10
  Scenario: normal user tries to delete a user
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    When user "Alice" deletes user "Brian" using the provisioning API
    Then the OCS status code should be "401"
    And the HTTP status code should be "401"
    And user "Brian" should exist
  @notToImplementOnOCIS
  Scenario: administrator deletes another admin user
    Given these users have been created with default attributes and without skeleton files:
      | username       |
      | another-admin  |
    And user "another-admin" has been added to group "admin"
    When the administrator deletes user "another-admin" using the provisioning API
    Then the OCS status code should be "200"
    And the HTTP status code should be "200"
    And user "another-admin" should not exist
  @notToImplementOnOCIS
  Scenario: subadmin deletes a user with subadmin permissions in their group
    Given these users have been created with default attributes and without skeleton files:
      | username         |
      | subadmin         |
      | another-subadmin |
    And group "new-group" has been created
    And user "another-subadmin" has been added to group "new-group"
    And user "another-subadmin" has been made a subadmin of group "new-group"
    And user "subadmin" has been made a subadmin of group "new-group"
    When user "subadmin" deletes user "another-subadmin" using the provisioning API
    Then the OCS status code should be "200"
    And the HTTP status code should be "200"
    And user "another-subadmin" should not exist
  @notToImplementOnOCIS
  Scenario: subadmin should not be able to delete another subadmin of same group
    Given these users have been created with default attributes and without skeleton files:
      | username         |
      | subadmin         |
      | another-subadmin |
    And group "new-group" has been created
    And user "another-subadmin" has been made a subadmin of group "new-group"
    And user "subadmin" has been made a subadmin of group "new-group"
    When user "subadmin" deletes user "another-subadmin" using the provisioning API
    Then the OCS status code should be "997"
    And the HTTP status code should be "401"
    And user "another-subadmin" should exist
  @notToImplementOnOCIS
  Scenario: subadmin should not be able to delete a user with admin permissions in their group
    Given these users have been created with default attributes and without skeleton files:
      | username       |
      | subadmin       |
      | another-admin  |
    And user "another-admin" has been added to group "admin"
    And group "new-group" has been created
    And user "another-admin" has been added to group "new-group"
    And user "subadmin" has been made a subadmin of group "new-group"
    When user "subadmin" deletes user "another-admin" using the provisioning API
    Then the OCS status code should be "997"
    And the HTTP status code should be "401"
    And user "another-admin" should exist
  @notToImplementOnOCIS
  Scenario: subadmin should not be able to delete a user not in their group
    Given these users have been created with default attributes and without skeleton files:
      | username       |
      | subadmin       |
      | brand-new-user |
    And group "new-group" has been created
    And user "subadmin" has been made a subadmin of group "new-group"
    When user "subadmin" deletes user "brand-new-user" using the provisioning API
    Then the OCS status code should be "997"
    And the HTTP status code should be "401"
    And user "brand-new-user" should exist
