@api @files_sharing-app-required @skipOnOcV10.6 @skipOnOcV10.7 @skipOnOcV10.8.0
Feature: resources shared with the same name are received with unique names

  Background:
    Given the administrator has set the default folder for received shares to "Shares"
    And auto-accept shares has been disabled
    And using OCS API version "1"
    And these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
      | Carol    |

  @smokeTest @issue-ocis-2131
  Scenario: unique target names for incoming shares
    Given user "Alice" has created folder "/foo"
    And user "Brian" has created folder "/foo"
    When user "Alice" shares folder "/foo" with user "Carol" using the sharing API
    And user "Carol" accepts share "/foo" offered by user "Alice" using the sharing API
    And user "Brian" shares folder "/foo" with user "Carol" using the sharing API
    And user "Carol" accepts share "/foo" offered by user "Brian" using the sharing API
    Then user "Carol" should see the following elements
      | /Shares/foo/       |
      | /Shares/foo (2)/ |
