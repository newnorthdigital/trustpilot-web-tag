___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Trustpilot",
  "categories": ["MARKETING", "CONVERSIONS"],
  "brand": {
    "id": "brand_dummy",
    "displayName": "New North Digital",
    "thumbnail": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAA5UExURUxpcQq2ewq2ewq2ewarcgq2ewq2ewq2ewm1egq2ewq2ewq2ewegaAFgMQFXKgq2ewSNWABQIwJzQYEtjkQAAAAPdFJOUwAFIm4+UeyH1hKjwfj9lxOm3ZQAAADISURBVDjLhZNbEoUgDENRWigPb9X9L/YqMigINZ+kzIEElKo1qQ/B/DHgtezP5GUIspEZnllkOGIWGcjMJDHsMcAoE0QGnL7ESISWgfYWXQPhsQRqtoaHMtod/SGN/AC5AN/fbl15BLqDIXxeF0Lr++ayrj4r6Xda+uFHGKd0al06A66cIu7b9uv0YMr2ZV/JjQgmrrHbeSYEyLnaLiFld+X6Ytg7O5dyxTfhzu7M1baE1Gz5P75laKqjmTRVjAlf7xDw69fnpT8AgBG8+ZTd5gAAAFd6VFh0UmF3IHByb2ZpbGUgdHlwZSBpcHRjAAB4nOPyDAhxVigoyk/LzEnlUgADIwsuYwsTIxNLkxQDEyBEgDTDZAMjs1Qgy9jUyMTMxBzEB8uASKBKLgDqFxF08kI1lQAAAABJRU5ErkJggg=="
  },
  "description": "Trustpilot TrustBox widgets and review invitations. Load the widget bootstrap or trigger review invitation emails on order confirmation.",
  "containerContexts": ["WEB"]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "actionType",
    "displayName": "Action type",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "trustbox",
        "displayValue": "Load TrustBox widgets"
      },
      {
        "value": "invitation",
        "displayValue": "Send review invitation"
      }
    ],
    "simpleValueType": true,
    "help": "Choose the Trustpilot integration to use. \u0027Load TrustBox widgets\u0027 injects the bootstrap script that auto-discovers TrustBox widget divs on the page. \u0027Send review invitation\u0027 triggers a review invitation email on the order confirmation page."
  },
  {
    "type": "TEXT",
    "name": "integrationKey",
    "displayName": "Integration Key",
    "simpleValueType": true,
    "help": "Your Trustpilot integration key (found in Business app under Integrations \u003e Ecommerce \u003e JavaScript Integration).",
    "alwaysInSummary": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "enablingConditions": [
      {
        "paramName": "actionType",
        "paramValue": "invitation",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "recipientEmail",
    "displayName": "Customer Email",
    "simpleValueType": true,
    "help": "The customer\u0027s email address for the review invitation.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "enablingConditions": [
      {
        "paramName": "actionType",
        "paramValue": "invitation",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "recipientName",
    "displayName": "Customer Name",
    "simpleValueType": true,
    "help": "The customer\u0027s name for the review invitation.",
    "enablingConditions": [
      {
        "paramName": "actionType",
        "paramValue": "invitation",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "referenceId",
    "displayName": "Order ID",
    "simpleValueType": true,
    "help": "Unique order/reference ID for the transaction.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "enablingConditions": [
      {
        "paramName": "actionType",
        "paramValue": "invitation",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "productSkus",
    "displayName": "Product SKUs (optional)",
    "simpleValueType": true,
    "help": "Comma-separated list of product SKUs for product review invitations. Leave empty for service reviews only.",
    "enablingConditions": [
      {
        "paramName": "actionType",
        "paramValue": "invitation",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "debugging",
    "displayName": "Debugging",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "debug",
        "checkboxText": "Log debug messages to console",
        "simpleValueType": true
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

var log = require('logToConsole');
var injectScript = require('injectScript');
var createArgumentsQueue = require('createArgumentsQueue');
var makeString = require('makeString');

var enableDebug = data.debug;
var debugLog = function(msg) {
  if (enableDebug) log('Trustpilot GTM - ' + msg);
};

var actionType = data.actionType;

if (actionType === 'trustbox') {
  // Load the TrustBox bootstrap script
  // It auto-discovers all trustpilot-widget divs on the page
  var bootstrapUrl = 'https://widget.trustpilot.com/bootstrap/v5/tp.widget.bootstrap.min.js';

  debugLog('Loading TrustBox bootstrap script');

  injectScript(bootstrapUrl, function() {
    debugLog('TrustBox bootstrap loaded');
    data.gtmOnSuccess();
  }, function() {
    debugLog('TrustBox bootstrap failed to load');
    data.gtmOnFailure();
  }, 'trustpilot-bootstrap');

} else if (actionType === 'invitation') {
  // Review invitation - uses command queue pattern
  var tp = createArgumentsQueue('tp', 'tp.q');

  // Register the integration
  var integrationKey = makeString(data.integrationKey);
  tp('register', integrationKey);
  debugLog('Registered with integration key');

  // Build invitation data
  var invitationData = {
    recipientEmail: makeString(data.recipientEmail),
    referenceId: makeString(data.referenceId),
    source: 'InvitationScript'
  };

  if (data.recipientName) {
    invitationData.recipientName = makeString(data.recipientName);
  }

  // Handle product SKUs - split comma-separated string into array
  if (data.productSkus) {
    var skuString = makeString(data.productSkus);
    var skus = skuString.split(',');
    var trimmedSkus = [];
    for (var i = 0; i < skus.length; i++) {
      var sku = skus[i];
      // Manual trim since .trim() may not be available
      var s = 0;
      var e = sku.length - 1;
      while (s < sku.length && sku.charAt(s) === ' ') s++;
      while (e > s && sku.charAt(e) === ' ') e--;
      if (s <= e) trimmedSkus.push(sku.substring(s, e + 1));
    }
    if (trimmedSkus.length > 0) {
      invitationData.productSkus = trimmedSkus;
    }
  }

  debugLog('Sending invitation for order: ' + invitationData.referenceId);

  // Create the invitation
  tp('createInvitation', invitationData);

  // Inject the invitation script
  var inviteUrl = 'https://invitejs.trustpilot.com/tp.min.js';

  injectScript(inviteUrl, function() {
    debugLog('Invitation script loaded');
    data.gtmOnSuccess();
  }, function() {
    debugLog('Invitation script failed to load');
    data.gtmOnFailure();
  }, 'trustpilot-invite');

} else {
  debugLog('Unknown action type');
  data.gtmOnFailure();
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "vpiId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://widget.trustpilot.com/*"
              },
              {
                "type": 1,
                "string": "https://invitejs.trustpilot.com/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "vpiId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "tp"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "tp.q"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "TrustpilotObject"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "vpiId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: TrustBox bootstrap loads successfully
  code: |-
    var mockData = {
      actionType: 'trustbox',
      debug: true
    };

    mock('injectScript', function(url, onSuccess, onFailure, cacheToken) {
      onSuccess();
    });

    runCode(mockData);

    assertApi('injectScript').wasCalledWith(
      'https://widget.trustpilot.com/bootstrap/v5/tp.widget.bootstrap.min.js',
      org.mockito.Matchers.any(),
      org.mockito.Matchers.any(),
      'trustpilot-bootstrap'
    );
    assertApi('gtmOnSuccess').wasCalled();

- name: Review invitation sends correctly
  code: |-
    var mockData = {
      actionType: 'invitation',
      integrationKey: 'abc123key',
      recipientEmail: 'john@example.com',
      recipientName: 'John Doe',
      referenceId: 'ORD-001',
      debug: true
    };

    mock('injectScript', function(url, onSuccess, onFailure, cacheToken) {
      onSuccess();
    });

    mock('createArgumentsQueue', function(fnName, arrayName) {
      return function() {};
    });

    runCode(mockData);

    assertApi('createArgumentsQueue').wasCalledWith('tp', 'tp.q');
    assertApi('injectScript').wasCalledWith(
      'https://invitejs.trustpilot.com/tp.min.js',
      org.mockito.Matchers.any(),
      org.mockito.Matchers.any(),
      'trustpilot-invite'
    );
    assertApi('gtmOnSuccess').wasCalled();

- name: Review invitation with product SKUs
  code: |-
    var mockData = {
      actionType: 'invitation',
      integrationKey: 'abc123key',
      recipientEmail: 'jane@example.com',
      recipientName: 'Jane Smith',
      referenceId: 'ORD-002',
      productSkus: 'SKU-001, SKU-002, SKU-003',
      debug: true
    };

    mock('injectScript', function(url, onSuccess, onFailure, cacheToken) {
      onSuccess();
    });

    var tpCalls = [];
    mock('createArgumentsQueue', function(fnName, arrayName) {
      return function() {
        tpCalls.push(arguments);
      };
    });

    runCode(mockData);

    assertApi('createArgumentsQueue').wasCalledWith('tp', 'tp.q');
    assertApi('gtmOnSuccess').wasCalled();

- name: Script failure calls gtmOnFailure
  code: |-
    var mockData = {
      actionType: 'trustbox',
      debug: true
    };

    mock('injectScript', function(url, onSuccess, onFailure, cacheToken) {
      onFailure();
    });

    runCode(mockData);

    assertApi('gtmOnFailure').wasCalled();
