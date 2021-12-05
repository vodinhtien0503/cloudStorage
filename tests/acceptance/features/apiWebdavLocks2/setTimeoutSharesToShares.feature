@api @smokeTest @public_link_share-feature-required @files_sharing-app-required @issue-ocis-reva-172 @skipOnOcV10.6 @skipOnOcV10.7 @skipOnOcV10.8.0
Feature: set timeouts of LOCKS on shares

  Background:
    Given the administrator has set the default folder for received shares to "Shares"
    And auto-accept shares has been disabled
    And these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And user "Alice" has created folder "PARENT"
    And user "Alice" has created folder "PARENT/CHILD"
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "PARENT/parent.txt"
    And user "Brian" has created folder "PARENT"
    And user "Brian" has created folder "PARENT/CHILD"
    And user "Brian" has uploaded file "filesForUpload/textfile.txt" to "PARENT/parent.txt"


  Scenario Outline: as owner set timeout on folder as receiver check it
    Given using <dav-path> DAV path
    And user "Alice" has shared folder "PARENT" with user "Brian"
    And user "Brian" has accepted share "/PARENT" offered by user "Alice"
    When user "Alice" locks folder "PARENT" using the WebDAV API setting the following properties
      | lockscope | shared    |
      | timeout   | <timeout> |
    And user "Brian" gets the following properties of folder "Shares/PARENT" using the WebDAV API
      | propertyName    |
      | d:lockdiscovery |
    Then the value of the item "//d:timeout" in the response to user "Brian" should match "<result>"
    When user "Brian" gets the following properties of folder "Shares/PARENT/CHILD" using the WebDAV API
      | propertyName    |
      | d:lockdiscovery |
    Then the value of the item "//d:timeout" in the response to user "Brian" should match "<result>"
    When user "Brian" gets the following properties of folder "Shares/PARENT/parent.txt" using the WebDAV API
      | propertyName    |
      | d:lockdiscovery |
    Then the value of the item "//d:timeout" in the response to user "Brian" should match "<result>"
    Examples:
      | dav-path | timeout         | result          |
      | old      | second-999      | /Second-\d{3}$/ |
      | old      | second-99999999 | /Second-\d{5}$/ |
      | old      | infinite        | /Second-\d{5}$/ |
      | old      | second--1       | /Second-\d{5}$/ |
      | old      | second-0        | /Second-\d{4}$/ |
      | new      | second-999      | /Second-\d{3}$/ |
      | new      | second-99999999 | /Second-\d{5}$/ |
      | new      | infinite        | /Second-\d{5}$/ |
      | new      | second--1       | /Second-\d{5}$/ |
      | new      | second-0        | /Second-\d{4}$/ |


  Scenario Outline: as share receiver set timeout on folder as owner check it
    Given using <dav-path> DAV path
    And user "Alice" has shared folder "PARENT" with user "Brian"
    And user "Brian" has accepted share "/PARENT" offered by user "Alice"
    When user "Brian" locks folder "Shares/PARENT" using the WebDAV API setting the following properties
      | lockscope | shared    |
      | timeout   | <timeout> |
    And user "Alice" gets the following properties of folder "PARENT" using the WebDAV API
      | propertyName    |
      | d:lockdiscovery |
    Then the value of the item "//d:timeout" in the response to user "Alice" should match "<result>"
    When user "Alice" gets the following properties of folder "PARENT/CHILD" using the WebDAV API
      | propertyName    |
      | d:lockdiscovery |
    Then the value of the item "//d:timeout" in the response to user "Alice" should match "<result>"
    When user "Alice" gets the following properties of folder "PARENT/parent.txt" using the WebDAV API
      | propertyName    |
      | d:lockdiscovery |
    Then the value of the item "//d:timeout" in the response to user "Alice" should match "<result>"
    Examples:
      | dav-path | timeout         | result          |
      | old      | second-999      | /Second-\d{3}$/ |
      | old      | second-99999999 | /Second-\d{5}$/ |
      | old      | infinite        | /Second-\d{5}$/ |
      | old      | second--1       | /Second-\d{5}$/ |
      | old      | second-0        | /Second-\d{4}$/ |
      | new      | second-999      | /Second-\d{3}$/ |
      | new      | second-99999999 | /Second-\d{5}$/ |
      | new      | infinite        | /Second-\d{5}$/ |
      | new      | second--1       | /Second-\d{5}$/ |
      | new      | second-0        | /Second-\d{4}$/ |
