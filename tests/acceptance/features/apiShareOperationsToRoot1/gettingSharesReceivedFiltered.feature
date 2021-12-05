@api @files_sharing-app-required @notToImplementOnOCIS @skipOnOcV10.3 @skipOnOcV10.4 @skipOnOcV10.5
Feature: get the received shares filtered by type (user, group etc)
  As a user
  I want to be able to know the shares that I have received of a particular type (user, group etc)
  So that I can reduce the amount of data that has to be transferred to be just the data that I need

  Background:
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Alice" has created folder "/folderToShareWithUser"
    And user "Alice" has created folder "/folderToShareWithGroup"
    And user "Alice" has created folder "/folderToShareWithPublic"
    And user "Alice" has uploaded file with content "file to share with user" to "/fileToShareWithUser.txt"
    And user "Alice" has uploaded file with content "file to share with group" to "/fileToShareWithGroup.txt"
    And user "Alice" has uploaded file with content "file to share with public" to "/fileToShareWithPublic.txt"
    And user "Alice" has shared folder "/folderToShareWithUser" with user "Brian"
    And user "Alice" has shared folder "/folderToShareWithGroup" with group "grp1"
    And user "Alice" has created a public link share with settings
      | path        | /folderToShareWithPublic |
      | permissions | read                     |
    And user "Alice" has shared file "/fileToShareWithUser.txt" with user "Brian"
    And user "Alice" has shared file "/fileToShareWithGroup.txt" with group "grp1"
    And user "Alice" has created a public link share with settings
      | path        | /fileToShareWithPublic.txt |
      | permissions | read                       |

  Scenario Outline: getting shares received from users
    Given using OCS API version "<ocs_api_version>"
    When user "Brian" gets the user shares shared with him using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And exactly 2 files or folders should be included in the response
    And folder "folderToShareWithUser" should be included in the response
    And file "fileToShareWithUser.txt" should be included in the response
    Examples:
      | ocs_api_version | ocs_status_code |
      | 1               | 100             |
      | 2               | 200             |

  Scenario Outline: getting shares received from groups
    Given using OCS API version "<ocs_api_version>"
    When user "Brian" gets the group shares shared with him using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And exactly 2 files or folders should be included in the response
    And folder "folderToShareWithGroup" should be included in the response
    And folder "fileToShareWithGroup.txt" should be included in the response
    Examples:
      | ocs_api_version | ocs_status_code |
      | 1               | 100             |
      | 2               | 200             |
