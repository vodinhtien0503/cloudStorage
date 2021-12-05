@api @files_sharing-app-required @issue-ocis-1328 @skipOnOcV10.6 @skipOnOcV10.7 @skipOnOcV10.8.0
Feature: sharing

  Background:
    Given the administrator has set the default folder for received shares to "Shares"
    And auto-accept shares has been disabled
    And these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
      | Carol    |

  @smokeTest
  Scenario Outline: User is not allowed to reshare file when reshare permission is not given
    Given using OCS API version "<ocs_api_version>"
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "/textfile0.txt"
    And user "Alice" has shared file "/textfile0.txt" with user "Brian" with permissions "read,update"
    And user "Brian" has accepted share "/textfile0.txt" offered by user "Alice"
    When user "Brian" shares file "/Shares/textfile0.txt" with user "Carol" with permissions "read,update" using the sharing API
    Then the OCS status code should be "404"
    And the HTTP status code should be "<http_status_code>"
    And as "Carol" file "/Shares/textfile0.txt" should not exist
    And the sharing API should report to user "Carol" that no shares are in the pending state
    But as "Brian" file "/Shares/textfile0.txt" should exist
    Examples:
      | ocs_api_version | http_status_code |
      | 1               | 200              |
      | 2               | 404              |

  Scenario Outline: User is not allowed to reshare folder when reshare permission is not given
    Given using OCS API version "<ocs_api_version>"
    And user "Alice" has created folder "/FOLDER"
    And user "Alice" has shared folder "/FOLDER" with user "Brian" with permissions "read,update"
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"
    When user "Brian" shares folder "/Shares/FOLDER" with user "Carol" with permissions "read,update" using the sharing API
    Then the OCS status code should be "404"
    And the HTTP status code should be "<http_status_code>"
    And as "Carol" folder "/Shares/FOLDER" should not exist
    And the sharing API should report to user "Carol" that no shares are in the pending state
    But as "Brian" folder "/Shares/FOLDER" should exist
    Examples:
      | ocs_api_version | http_status_code |
      | 1               | 200              |
      | 2               | 404              |

  @smokeTest
  Scenario Outline: User is allowed to reshare file with the same permissions
    Given using OCS API version "<ocs_api_version>"
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "/textfile0.txt"
    And user "Alice" has shared file "/textfile0.txt" with user "Brian" with permissions "share,read"
    And user "Brian" has accepted share "/textfile0.txt" offered by user "Alice"
    When user "Brian" shares file "/Shares/textfile0.txt" with user "Carol" with permissions "share,read" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    When user "Carol" accepts share "/textfile0.txt" offered by user "Brian" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And as "Carol" file "/Shares/textfile0.txt" should exist
    Examples:
      | ocs_api_version | ocs_status_code |
      | 1               | 100             |
      | 2               | 200             |

  Scenario Outline: User is allowed to reshare folder with the same permissions
    Given using OCS API version "<ocs_api_version>"
    And user "Alice" has created folder "/FOLDER"
    And user "Alice" has shared folder "/FOLDER" with user "Brian" with permissions "share,read"
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"
    When user "Brian" shares folder "/Shares/FOLDER" with user "Carol" with permissions "share,read" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    When user "Carol" accepts share "/FOLDER" offered by user "Brian" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And as "Carol" folder "/Shares/FOLDER" should exist
    Examples:
      | ocs_api_version | ocs_status_code |
      | 1               | 100             |
      | 2               | 200             |

  Scenario Outline: User is allowed to reshare file with less permissions
    Given using OCS API version "<ocs_api_version>"
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "/textfile0.txt"
    And user "Alice" has shared file "/textfile0.txt" with user "Brian" with permissions "share,update,read"
    And user "Brian" has accepted share "/textfile0.txt" offered by user "Alice"
    When user "Brian" shares file "/Shares/textfile0.txt" with user "Carol" with permissions "share,read" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    When user "Carol" accepts share "/textfile0.txt" offered by user "Brian" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And as "Carol" file "/Shares/textfile0.txt" should exist
    Examples:
      | ocs_api_version | ocs_status_code |
      | 1               | 100             |
      | 2               | 200             |

  Scenario Outline: User is allowed to reshare folder with less permissions
    Given using OCS API version "<ocs_api_version>"
    And user "Alice" has created folder "/FOLDER"
    And user "Alice" has shared folder "/FOLDER" with user "Brian" with permissions "share,update,read"
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"
    When user "Brian" shares folder "/Shares/FOLDER" with user "Carol" with permissions "share,read" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    When user "Carol" accepts share "/FOLDER" offered by user "Brian" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And as "Carol" folder "/Shares/FOLDER" should exist
    Examples:
      | ocs_api_version | ocs_status_code |
      | 1               | 100             |
      | 2               | 200             |

  Scenario Outline: User is not allowed to reshare file and set more permissions bits
    Given using OCS API version "<ocs_api_version>"
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "/textfile0.txt"
    And user "Alice" has shared file "/textfile0.txt" with user "Brian" with permissions <received_permissions>
    And user "Brian" has accepted share "/textfile0.txt" offered by user "Alice"
    When user "Brian" shares file "/Shares/textfile0.txt" with user "Carol" with permissions <reshare_permissions> using the sharing API
    Then the OCS status code should be "404"
    And the HTTP status code should be "<http_status_code>"
    And as "Carol" file "/Shares/textfile0.txt" should not exist
    And the sharing API should report to user "Carol" that no shares are in the pending state
    But as "Brian" file "/Shares/textfile0.txt" should exist
    Examples:
      | ocs_api_version | http_status_code | received_permissions | reshare_permissions |
      # passing on more bits including reshare
      | 1               | 200              | 17                   | 19                  |
      | 2               | 404              | 17                   | 19                  |
      | 1               | 200              | 17                   | 23                  |
      | 2               | 404              | 17                   | 23                  |
      | 1               | 200              | 17                   | 31                  |
      | 2               | 404              | 17                   | 31                  |
      # passing on more bits but not reshare
      | 1               | 200              | 17                   | 3                   |
      | 2               | 404              | 17                   | 3                   |
      | 1               | 200              | 17                   | 7                   |
      | 2               | 404              | 17                   | 7                   |
      | 1               | 200              | 17                   | 15                  |
      | 2               | 404              | 17                   | 15                  |

  @skipOnOcV10.3 @skipOnOcV10.4 @skipOnOcV10.5
  Scenario Outline: User is allowed to reshare file and set create (4) or delete (8) permissions bits, which get ignored
    Given using OCS API version "<ocs_api_version>"
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "/textfile0.txt"
    And user "Alice" has shared file "/textfile0.txt" with user "Brian" with permissions <received_permissions>
    And user "Brian" has accepted share "/textfile0.txt" offered by user "Alice"
    When user "Brian" shares file "/Shares/textfile0.txt" with user "Carol" with permissions <reshare_permissions> using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    When user "Carol" accepts share "/textfile0.txt" offered by user "Brian" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And the fields of the last response to user "Brian" sharing with user "Carol" should include
      | share_with  | %username%            |
      | file_target | /Shares/textfile0.txt |
      | path        | /Shares/textfile0.txt |
      | permissions | <granted_permissions> |
      | uid_owner   | %username%            |
    And as "Carol" file "/Shares/textfile0.txt" should exist
    # The receiver of the reshare can always delete their received share, even though they do not have delete permission
    And user "Carol" should be able to delete file "/Shares/textfile0.txt"
    # But the upstream sharers will still have the file
    But as "Brian" file "/Shares/textfile0.txt" should exist
    And as "Alice" file "/textfile0.txt" should exist
    Examples:
      | ocs_api_version | ocs_status_code | received_permissions | reshare_permissions | granted_permissions |
      | 1               | 100             | 19                   | 23                  | 19                  |
      | 2               | 200             | 19                   | 23                  | 19                  |
      | 1               | 100             | 19                   | 31                  | 19                  |
      | 2               | 200             | 19                   | 31                  | 19                  |
      | 1               | 100             | 19                   | 7                   | 3                   |
      | 2               | 200             | 19                   | 7                   | 3                   |
      | 1               | 100             | 19                   | 15                  | 3                   |
      | 2               | 200             | 19                   | 15                  | 3                   |
      | 1               | 100             | 17                   | 21                  | 17                  |
      | 2               | 200             | 17                   | 21                  | 17                  |
      | 1               | 100             | 17                   | 5                   | 1                   |
      | 2               | 200             | 17                   | 5                   | 1                   |
      | 1               | 100             | 17                   | 25                  | 17                  |
      | 2               | 200             | 17                   | 25                  | 17                  |
      | 1               | 100             | 17                   | 9                   | 1                   |
      | 2               | 200             | 17                   | 9                   | 1                   |

  Scenario Outline: User is not allowed to reshare folder and set more permissions bits
    Given using OCS API version "<ocs_api_version>"
    And user "Alice" has created folder "/PARENT"
    And user "Alice" has shared folder "/PARENT" with user "Brian" with permissions <received_permissions>
    And user "Brian" has accepted share "/PARENT" offered by user "Alice"
    When user "Brian" shares folder "/Shares/PARENT" with user "Carol" with permissions <reshare_permissions> using the sharing API
    Then the OCS status code should be "404"
    And the HTTP status code should be "<http_status_code>"
    And as "Carol" folder "/Shares/PARENT" should not exist
    And the sharing API should report to user "Carol" that no shares are in the pending state
    But as "Brian" folder "/Shares/PARENT" should exist
    Examples:
      | ocs_api_version | http_status_code | received_permissions | reshare_permissions |
      # try to pass on more bits including reshare
      | 1               | 200              | 17                   | 19                  |
      | 2               | 404              | 17                   | 19                  |
      | 1               | 200              | 17                   | 21                  |
      | 2               | 404              | 17                   | 21                  |
      | 1               | 200              | 17                   | 23                  |
      | 2               | 404              | 17                   | 23                  |
      | 1               | 200              | 17                   | 31                  |
      | 2               | 404              | 17                   | 31                  |
      | 1               | 200              | 19                   | 23                  |
      | 2               | 404              | 19                   | 23                  |
      | 1               | 200              | 19                   | 31                  |
      | 2               | 404              | 19                   | 31                  |
      # try to pass on more bits but not reshare
      | 1               | 200              | 17                   | 3                   |
      | 2               | 404              | 17                   | 3                   |
      | 1               | 200              | 17                   | 5                   |
      | 2               | 404              | 17                   | 5                   |
      | 1               | 200              | 17                   | 7                   |
      | 2               | 404              | 17                   | 7                   |
      | 1               | 200              | 17                   | 15                  |
      | 2               | 404              | 17                   | 15                  |
      | 1               | 200              | 19                   | 7                   |
      | 2               | 404              | 19                   | 7                   |
      | 1               | 200              | 19                   | 15                  |
      | 2               | 404              | 19                   | 15                  |

  Scenario Outline: User is not allowed to reshare folder and add delete permission bit (8)
    Given using OCS API version "<ocs_api_version>"
    And user "Alice" has created folder "/PARENT"
    And user "Alice" has shared folder "/PARENT" with user "Brian" with permissions <received_permissions>
    And user "Brian" has accepted share "/PARENT" offered by user "Alice"
    When user "Brian" shares folder "/Shares/PARENT" with user "Carol" with permissions <reshare_permissions> using the sharing API
    Then the OCS status code should be "404"
    And the HTTP status code should be "<http_status_code>"
    And as "Carol" folder "/Shares/PARENT" should not exist
    And the sharing API should report to user "Carol" that no shares are in the pending state
    But as "Brian" folder "/Shares/PARENT" should exist
    Examples:
      | ocs_api_version | http_status_code | received_permissions | reshare_permissions |
      # try to pass on extra delete (including reshare)
      | 1               | 200              | 17                   | 25                  |
      | 2               | 404              | 17                   | 25                  |
      | 1               | 200              | 19                   | 27                  |
      | 2               | 404              | 19                   | 27                  |
      | 1               | 200              | 23                   | 31                  |
      | 2               | 404              | 23                   | 31                  |
      # try to pass on extra delete (but not reshare)
      | 1               | 200              | 17                   | 9                   |
      | 2               | 404              | 17                   | 9                   |
      | 1               | 200              | 19                   | 11                  |
      | 2               | 404              | 19                   | 11                  |
      | 1               | 200              | 23                   | 15                  |
      | 2               | 404              | 23                   | 15                  |


  Scenario Outline: Reshare a file with same name as a deleted file
    Given using OCS API version "<ocs_api_version>"
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "/textfile0.txt"
    And user "Alice" has shared file "textfile0.txt" with user "Brian"
    And user "Brian" has accepted share "/textfile0.txt" offered by user "Alice"
    And user "Alice" has deleted file "textfile0.txt"
    And user "Alice" has uploaded file with content "ownCloud new test text file 0" to "/textfile0.txt"
    When user "Alice" shares file "textfile0.txt" with user "Brian" using the sharing API
    And user "Brian" accepts share "/textfile0.txt" offered by user "Alice" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And the content of file "/Shares/textfile0.txt" for user "Brian" should be "ownCloud new test text file 0"
    Examples:
      | ocs_api_version | ocs_status_code |
      | 1               | 100             |
      | 2               | 200             |


  Scenario Outline: Reshare a folder with same name as a deleted folder
    Given using OCS API version "<ocs_api_version>"
    And user "Alice" has created folder "/PARENT"
    And user "Alice" has shared folder "PARENT" with user "Brian"
    And user "Brian" has accepted share "/PARENT" offered by user "Alice"
    And user "Alice" has deleted folder "PARENT"
    And user "Alice" has created folder "/PARENT"
    When user "Alice" shares folder "PARENT" with user "Brian" using the sharing API
    And user "Brian" accepts share "/PARENT" offered by user "Alice" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And as "Brian" folder "/Shares/PARENT" should exist
    Examples:
      | ocs_api_version | ocs_status_code |
      | 1               | 100             |
      | 2               | 200             |


  Scenario Outline: Reshare a folder with same name as a deleted file
    Given using OCS API version "<ocs_api_version>"
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "/textfile0.txt"
    And user "Alice" has shared file "textfile0.txt" with user "Brian"
    And user "Brian" has accepted share "/textfile0.txt" offered by user "Alice"
    And user "Alice" has deleted file "/textfile0.txt"
    And user "Alice" has created folder "/textfile0.txt"
    When user "Alice" shares folder "textfile0.txt" with user "Brian" using the sharing API
    And user "Brian" accepts share "/textfile0.txt" offered by user "Alice" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And as "Brian" folder "/Shares/textfile0.txt" should exist
    Examples:
      | ocs_api_version | ocs_status_code |
      | 1               | 100             |
      | 2               | 200             |
