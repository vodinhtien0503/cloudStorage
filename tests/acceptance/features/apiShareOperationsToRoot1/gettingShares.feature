@api @files_sharing-app-required @notToImplementOnOCIS
Feature: sharing

  Background:
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "textfile0.txt"

  @smokeTest
  Scenario Outline: getting all shares of a user using that user
    Given using OCS API version "<ocs_api_version>"
    And user "Alice" has moved file "/textfile0.txt" to "/file_to_share.txt"
    And user "Alice" has shared file "file_to_share.txt" with user "Brian"
    When user "Alice" gets all shares shared by him using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And file "file_to_share.txt" should be included in the response
    Examples:
      | ocs_api_version | ocs_status_code |
      | 1               | 100             |
      | 2               | 200             |

  Scenario Outline: getting all shares of a user using another user
    Given using OCS API version "<ocs_api_version>"
    And user "Alice" has shared file "textfile0.txt" with user "Brian"
    When the administrator gets all shares shared by him using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And file "textfile0.txt" should not be included in the response
    Examples:
      | ocs_api_version | ocs_status_code |
      | 1               | 100             |
      | 2               | 200             |

  @smokeTest
  Scenario Outline: getting all shares of a file
    Given using OCS API version "<ocs_api_version>"
    And these users have been created with default attributes and without skeleton files:
      | username |
      | Carol    |
      | David    |
    And user "Alice" has shared file "textfile0.txt" with user "Brian"
    And user "Alice" has shared file "textfile0.txt" with user "Carol"
    When user "Alice" gets all the shares from the file "textfile0.txt" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And user "Brian" should be included in the response
    And user "Carol" should be included in the response
    And user "David" should not be included in the response
    Examples:
      | ocs_api_version | ocs_status_code |
      | 1               | 100             |
      | 2               | 200             |

  @smokeTest
  Scenario Outline: getting all shares of a file with reshares
    Given using OCS API version "<ocs_api_version>"
    And these users have been created with default attributes and without skeleton files:
      | username |
      | Carol    |
      | David    |
    And user "Alice" has shared file "textfile0.txt" with user "Brian"
    And user "Brian" has shared file "textfile0.txt" with user "Carol"
    When user "Alice" gets all the shares with reshares from the file "textfile0.txt" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And user "Brian" should be included in the response
    And user "Carol" should be included in the response
    And user "David" should not be included in the response
    Examples:
      | ocs_api_version | ocs_status_code |
      | 1               | 100             |
      | 2               | 200             |

  @smokeTest
  Scenario Outline: User's own shares reshared to him don't appear when getting "shared with me" shares
    Given using OCS API version "<ocs_api_version>"
    And group "grp1" has been created
    And user "Carol" has been created with default attributes and without skeleton files
    And user "Carol" has been added to group "grp1"
    And user "Carol" has created folder "/shared"
    And user "Carol" has uploaded file "/filesForUpload/textfile.txt" to "/shared/shared_file.txt"
    And user "Carol" has shared folder "/shared" with user "Brian"
    And user "Brian" has shared folder "/shared" with group "grp1"
    When user "Carol" gets all the shares shared with him using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And the last share id should not be included in the response
    Examples:
      | ocs_api_version | ocs_status_code |
      | 1               | 100             |
      | 2               | 200             |

  @issue-ocis-reva-374
  Scenario Outline: Get a share with a user that didn't receive the share
    Given using OCS API version "<ocs_api_version>"
    And user "Carol" has been created with default attributes and without skeleton files
    And user "Carol" has uploaded file "/filesForUpload/textfile.txt" to "/textfile0.txt"
    And user "Alice" has shared file "textfile0.txt" with user "Brian"
    When user "Carol" gets the info of the last share using the sharing API
    Then the OCS status code should be "404"
    And the HTTP status code should be "<http_status_code>"
    Examples:
      | ocs_api_version | http_status_code |
      | 1               | 200              |
      | 2               | 404              |

  @skipOnLDAP
  Scenario: Share of folder to a group, remove user from that group
    Given using OCS API version "1"
    And user "Carol" has been created with default attributes and without skeleton files
    And user "Carol" has uploaded file "filesForUpload/textfile.txt" to "textfile0.txt"
    And group "group0" has been created
    And user "Brian" has been added to group "group0"
    And user "Carol" has been added to group "group0"
    And user "Alice" has created folder "/PARENT"
    And user "Alice" has moved file "textfile0.txt" to "PARENT/parent.txt"
    And user "Alice" has shared folder "/PARENT" with group "group0"
    When the administrator removes user "Carol" from group "group0" using the provisioning API
    Then user "Brian" should see the following elements
      | /PARENT/                 |
      | /PARENT/parent.txt       |
    And user "Carol" should see the following elements
      | textfile0.txt        |
    But user "Carol" should not see the following elements
      | /PARENT/           |
      | /PARENT/parent.txt |

  Scenario Outline: getting all the shares inside the folder
    Given using OCS API version "<ocs_api_version>"
    And user "Alice" has created folder "/PARENT"
    And user "Alice" has moved file "textfile0.txt" to "PARENT/parent.txt"
    And user "Alice" has shared file "PARENT/parent.txt" with user "Brian"
    When user "Alice" gets all the shares inside the folder "PARENT" using the sharing API
    Then the OCS status code should be "<ocs_status_code>"
    And the HTTP status code should be "200"
    And file "parent.txt" should be included in the response
    Examples:
      | ocs_api_version | ocs_status_code |
      | 1               | 100             |
      | 2               | 200             |
