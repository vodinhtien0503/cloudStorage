@api
Feature: propagation of etags when uploading data

  Background:
    Given user "Alice" has been created with default attributes and without skeleton files
    And the administrator has set the default folder for received shares to "Shares"
    And parameter "shareapi_auto_accept_share" of app "core" has been set to "no"
    And user "Alice" has created folder "/upload"

  @skipOnOcis-OC-Storage @issue-product-280
  Scenario Outline: uploading a file inside a folder changes its etag
    Given using <dav_version> DAV path
    And user "Alice" has stored etag of element "/"
    And user "Alice" has stored etag of element "/upload"
    When user "Alice" uploads file with content "uploaded content" to "/upload/file.txt" using the WebDAV API
    Then the content of file "/upload/file.txt" for user "Alice" should be "uploaded content"
    And these etags should have changed:
      | user  | path    |
      | Alice | /       |
      | Alice | /upload |
    Examples:
      | dav_version |
      | old         |
      | new         |


  Scenario Outline: overwriting a file inside a folder changes its etag
    Given using <dav_version> DAV path
    And user "Alice" has uploaded file with content "uploaded content" to "/upload/file.txt"
    And user "Alice" has stored etag of element "/"
    And user "Alice" has stored etag of element "/upload"
    And user "Alice" has stored etag of element "/upload/file.txt"
    When user "Alice" uploads file with content "new content" to "/upload/file.txt" using the WebDAV API
    Then the content of file "/upload/file.txt" for user "Alice" should be "new content"
    And these etags should have changed:
      | user  | path             |
      | Alice | /                |
      | Alice | /upload          |
      | Alice | /upload/file.txt |
    Examples:
      | dav_version |
      | old         |
      | new         |

  @skipOnOcis-OC-Storage @issue-product-280 @skipOnOcV10.6 @skipOnOcV10.7 @skipOnOcV10.8.0
  Scenario Outline: as share receiver uploading a file inside a received shared folder should update etags for all collaborators
    Given user "Brian" has been created with default attributes and without skeleton files
    And using <dav_version> DAV path
    And user "Alice" has shared folder "/upload" with user "Brian"
    And user "Brian" has accepted share "/upload" offered by user "Alice"
    And user "Alice" has stored etag of element "/"
    And user "Alice" has stored etag of element "/upload"
    And user "Brian" has stored etag of element "/"
    And user "Brian" has stored etag of element "/Shares"
    And user "Brian" has stored etag of element "/Shares/upload"
    When user "Brian" uploads file with content "uploaded content" to "/Shares/upload/file.txt" using the WebDAV API
    Then these etags should have changed:
      | user  | path           |
      | Alice | /              |
      | Alice | /upload        |
      | Brian | /              |
      | Brian | /Shares        |
      | Brian | /Shares/upload |
    Examples:
      | dav_version |
      | old         |
      | new         |

  @skipOnOcis-OC-Storage @issue-product-280 @skipOnOcV10.6 @skipOnOcV10.7 @skipOnOcV10.8.0
  Scenario Outline: as sharer uploading a file inside a shared folder should update etags for all collaborators
    Given user "Brian" has been created with default attributes and without skeleton files
    And using <dav_version> DAV path
    And user "Alice" has shared folder "/upload" with user "Brian"
    And user "Brian" has accepted share "/upload" offered by user "Alice"
    And user "Alice" has stored etag of element "/"
    And user "Alice" has stored etag of element "/upload"
    And user "Brian" has stored etag of element "/"
    And user "Brian" has stored etag of element "/Shares"
    And user "Brian" has stored etag of element "/Shares/upload"
    When user "Alice" uploads file with content "uploaded content" to "/upload/file.txt" using the WebDAV API
    Then these etags should have changed:
      | user  | path           |
      | Alice | /              |
      | Alice | /upload        |
      | Brian | /              |
      | Brian | /Shares        |
      | Brian | /Shares/upload |
    Examples:
      | dav_version |
      | old         |
      | new         |

  @skipOnOcV10.6 @skipOnOcV10.7 @skipOnOcV10.8.0
  Scenario Outline: as share receiver overwriting a file inside a received shared folder should update etags for all collaborators
    Given user "Brian" has been created with default attributes and without skeleton files
    And using <dav_version> DAV path
    And user "Alice" has uploaded file with content "uploaded content" to "/upload/file.txt"
    And user "Alice" has shared folder "/upload" with user "Brian"
    And user "Brian" has accepted share "/upload" offered by user "Alice"
    And user "Alice" has stored etag of element "/"
    And user "Alice" has stored etag of element "/upload"
    And user "Brian" has stored etag of element "/"
    And user "Brian" has stored etag of element "/Shares"
    And user "Brian" has stored etag of element "/Shares/upload"
    When user "Brian" uploads file with content "new content" to "/Shares/upload/file.txt" using the WebDAV API
    Then these etags should have changed:
      | user  | path           |
      | Alice | /              |
      | Alice | /upload        |
      | Brian | /              |
      | Brian | /Shares        |
      | Brian | /Shares/upload |
    Examples:
      | dav_version |
      | old         |
      | new         |

  @skipOnOcV10.6 @skipOnOcV10.7 @skipOnOcV10.8.0
  Scenario Outline: as sharer overwriting a file inside a shared folder should update etags for all collaborators
    Given user "Brian" has been created with default attributes and without skeleton files
    And using <dav_version> DAV path
    And user "Alice" has uploaded file with content "uploaded content" to "/upload/file.txt"
    And user "Alice" has shared folder "/upload" with user "Brian"
    And user "Brian" has accepted share "/upload" offered by user "Alice"
    And user "Alice" has stored etag of element "/"
    And user "Alice" has stored etag of element "/upload"
    And user "Brian" has stored etag of element "/"
    And user "Brian" has stored etag of element "/Shares"
    And user "Brian" has stored etag of element "/Shares/upload"
    When user "Alice" uploads file with content "new content" to "/upload/file.txt" using the WebDAV API
    Then these etags should have changed:
      | user  | path           |
      | Alice | /              |
      | Alice | /upload        |
      | Brian | /              |
      | Brian | /Shares        |
      | Brian | /Shares/upload |
    Examples:
      | dav_version |
      | old         |
      | new         |

  @skipOnOcis-OC-Storage @issue-product-280
  Scenario: uploading a file into a publicly shared folder changes its etag for the sharer
    Given user "Alice" has created a public link share with settings
      | path        | upload |
      | permissions | create |
    And user "Alice" has stored etag of element "/"
    And user "Alice" has stored etag of element "/upload"
    When the public uploads file "file.txt" with content "new content" using the new public WebDAV API
    Then these etags should have changed:
      | user  | path    |
      | Alice | /       |
      | Alice | /upload |
