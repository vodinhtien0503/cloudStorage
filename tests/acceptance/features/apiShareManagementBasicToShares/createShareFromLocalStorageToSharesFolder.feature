@api @local_storage @notToImplementOnOCIS @files_sharing-app-required
Feature: local-storage

  Background:
    Given the administrator has set the default folder for received shares to "Shares"
    And auto-accept shares has been disabled
    And these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |


  @skipOnEncryptionType:user-keys @encryption-issue-181
  Scenario Outline: Share a file inside a local external storage
    Given using OCS API version "<ocs_api_version>"
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "/local_storage/filetoshare.txt"
    When user "Alice" shares file "/local_storage/filetoshare.txt" with user "Brian" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And the fields of the last response to user "Alice" sharing with user "Brian" should include
      | share_with             | %username%                     |
      | share_with_displayname | %displayname%                  |
      | file_target            | /Shares/filetoshare.txt        |
      | path                   | /local_storage/filetoshare.txt |
      | permissions            | share,read,update              |
      | uid_owner              | %username%                     |
      | displayname_owner      | %displayname%                  |
      | item_type              | file                           |
      | mimetype               | text/plain                     |
      | storage_id             | ANY_VALUE                      |
      | share_type             | user                           |
    When user "Brian" accepts share "<pending_share_path>" offered by user "Alice" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And as "Brian" file "/Shares/filetoshare.txt" should exist
    @skipOnOcV10.6 @skipOnOcV10.7 @skipOnOcV10.8.0
    Examples:
      | ocs_api_version | ocs_status_code | pending_share_path  |
      | 1               | 100             | /filetoshare.txt    |
      | 2               | 200             | /filetoshare.txt    |

    @skipOnAllVersionsGreaterThanOcV10.8.0 @skipOnOcis @skipOnOcV10.6 @skipOnOcV10.7 @skipOnOcV10.8.0
    Examples:
      | ocs_api_version | ocs_status_code | pending_share_path             |
      | 1               | 100             | /local_storage/filetoshare.txt |
      | 2               | 200             | /local_storage/filetoshare.txt |


  Scenario Outline: Share a folder inside a local external storage
    Given using OCS API version "<ocs_api_version>"
    And user "Alice" has created folder "/local_storage/foo"
    When user "Alice" shares folder "/local_storage/foo" with user "Brian" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And the fields of the last response to user "Alice" sharing with user "Brian" should include
      | share_with             | %username%           |
      | share_with_displayname | %displayname%        |
      | file_target            | /Shares/foo          |
      | path                   | /local_storage/foo   |
      | permissions            | all                  |
      | uid_owner              | %username%           |
      | displayname_owner      | %displayname%        |
      | item_type              | folder               |
      | mimetype               | httpd/unix-directory |
      | storage_id             | ANY_VALUE            |
      | share_type             | user                 |
    Examples:
      | ocs_api_version | ocs_status_code |
      | 1               | 100             |
      | 2               | 200             |

  @skipOnEncryptionType:user-keys @encryption-issue-181
  Scenario Outline: Share a file inside a local external storage to a group
    Given using OCS API version "<ocs_api_version>"
    And group "grp1" has been created
    And user "Alice" has been added to group "grp1"
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "/local_storage/filetoshare.txt"
    When user "Alice" shares file "/local_storage/filetoshare.txt" with group "grp1" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And the fields of the last response to user "Alice" sharing with group "grp1" should include
      | share_with             | grp1                           |
      | share_with_displayname | grp1                           |
      | file_target            | /Shares/filetoshare.txt        |
      | path                   | /local_storage/filetoshare.txt |
      | permissions            | share,read,update              |
      | uid_owner              | %username%                     |
      | displayname_owner      | %displayname%                  |
      | item_type              | file                           |
      | mimetype               | text/plain                     |
      | storage_id             | ANY_VALUE                      |
      | share_type             | group                          |
    Examples:
      | ocs_api_version | ocs_status_code |
      | 1               | 100             |
      | 2               | 200             |


  Scenario Outline: Share a folder inside a local external storage to a group
    Given using OCS API version "<ocs_api_version>"
    And group "grp1" has been created
    And user "Alice" has been added to group "grp1"
    And user "Alice" has created folder "/local_storage/foo"
    When user "Alice" shares folder "/local_storage/foo" with group "grp1" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And the fields of the last response to user "Alice" sharing with group "grp1" should include
      | share_with             | grp1                 |
      | share_with_displayname | grp1                 |
      | file_target            | /Shares/foo          |
      | path                   | /local_storage/foo   |
      | permissions            | all                  |
      | uid_owner              | %username%           |
      | displayname_owner      | %displayname%        |
      | item_type              | folder               |
      | mimetype               | httpd/unix-directory |
      | storage_id             | ANY_VALUE            |
      | share_type             | group                |
    Examples:
      | ocs_api_version | ocs_status_code |
      | 1               | 100             |
      | 2               | 200             |
