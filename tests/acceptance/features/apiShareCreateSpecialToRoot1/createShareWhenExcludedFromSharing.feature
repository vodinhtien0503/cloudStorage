@api @files_sharing-app-required @notToImplementOnOCIS
Feature: cannot share resources when in a group that is excluded from sharing

  Background:
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |

  Scenario Outline: user who is excluded from sharing tries to share a file with another user
    Given using OCS API version "<ocs_api_version>"
    And user "Brian" has uploaded file "filesForUpload/textfile.txt" to "/fileToShare.txt"
    And group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And parameter "shareapi_exclude_groups" of app "core" has been set to "yes"
    And parameter "shareapi_exclude_groups_list" of app "core" has been set to '["grp1"]'
    When user "Brian" shares file "fileToShare.txt" with user "Alice" using the sharing API
    Then the OCS status code should be "403"
    And the HTTP status code should be "<http_status_code>"
    And as "Alice" file "fileToShare.txt" should not exist
    Examples:
      | ocs_api_version | http_status_code |
      | 1               | 200              |
      | 2               | 403              |

  Scenario Outline: user who is excluded from sharing tries to share a file with a group
    Given using OCS API version "<ocs_api_version>"
    And user "Carol" has been created with default attributes and without skeleton files
    And these groups have been created:
      | groupname |
      | grp1      |
      | grp2      |
    And user "Brian" has been added to group "grp1"
    And user "Carol" has been added to group "grp2"
    And parameter "shareapi_exclude_groups" of app "core" has been set to "yes"
    And parameter "shareapi_exclude_groups_list" of app "core" has been set to '["grp1"]'
    And user "Brian" has uploaded file "filesForUpload/textfile.txt" to "/fileToShare.txt"
    When user "Brian" shares file "fileToShare.txt" with group "grp2" using the sharing API
    Then the OCS status code should be "403"
    And the HTTP status code should be "<http_status_code>"
    And as "Carol" file "fileToShare.txt" should not exist
    Examples:
      | ocs_api_version | http_status_code |
      | 1               | 200              |
      | 2               | 403              |

  Scenario Outline: user who is excluded from sharing tries to share a folder with another user
    Given using OCS API version "<ocs_api_version>"
    And group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And parameter "shareapi_exclude_groups" of app "core" has been set to "yes"
    And parameter "shareapi_exclude_groups_list" of app "core" has been set to '["grp1"]'
    And user "Brian" has created folder "folderToShare"
    When user "Brian" shares folder "folderToShare" with user "Alice" using the sharing API
    Then the OCS status code should be "403"
    And the HTTP status code should be "<http_status_code>"
    And as "Alice" folder "folderToShare" should not exist
    Examples:
      | ocs_api_version | http_status_code |
      | 1               | 200              |
      | 2               | 403              |

  Scenario Outline: user who is excluded from sharing tries to share a folder with a group
    Given using OCS API version "<ocs_api_version>"
    And group "grp0" has been created
    And group "grp1" has been created
    And user "Alice" has been added to group "grp0"
    And user "Brian" has been added to group "grp1"
    And parameter "shareapi_exclude_groups" of app "core" has been set to "yes"
    And parameter "shareapi_exclude_groups_list" of app "core" has been set to '["grp0"]'
    And user "Alice" has created folder "folderToShare"
    When user "Alice" shares folder "folderToShare" with group "grp1" using the sharing API
    Then the OCS status code should be "403"
    And the HTTP status code should be "<http_status_code>"
    And as "Brian" folder "folderToShare" should not exist
    Examples:
      | ocs_api_version | http_status_code |
      | 1               | 200              |
      | 2               | 403              |
