___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Dialog",
  "categories": [
    "ANALYTICS",
    "PERSONALIZATION"
  ],
  "brand": {
    "id": "brand_dummy",
    "displayName": "Dialog"
  },
  "description": "Runs Dialog on your store: the assistant, the product block, and the measurement of the GA4 e-commerce events your store pushes to the dataLayer, sent only while GTM reports analytics_storage as granted. Fire it on Initialization - All Pages, History Change, and a custom event matching view_item_list, view_item, add_to_cart, remove_from_cart, view_cart, begin_checkout, add_shipping_info, add_payment_info and purchase.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "apiKey",
    "displayName": "API key",
    "simpleValueType": true,
    "help": "The store's Dialog API key, given by Dialog.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "productId",
    "displayName": "Product ID",
    "simpleValueType": true,
    "help": "Optional. The product shown on the page, usually a variable. Leave empty to use the first item_id of the page's view_item event."
  },
  {
    "type": "SELECT",
    "name": "disableAddToCart",
    "displayName": "Disable add-to-cart",
    "macrosInSelect": true,
    "selectItems": [
      {
        "value": "false",
        "displayValue": "No"
      },
      {
        "value": "true",
        "displayValue": "Yes"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "false",
    "help": "Yes hides the assistant's add-to-cart buttons. Accepts a variable returning true or false."
  },
  {
    "type": "SELECT",
    "name": "hideDialog",
    "displayName": "Hide Dialog",
    "macrosInSelect": true,
    "selectItems": [
      {
        "value": "false",
        "displayValue": "No"
      },
      {
        "value": "true",
        "displayValue": "Yes"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "false",
    "help": "Yes shows neither the assistant nor the product block; measurement continues. For A/B tests, use a variable returning true or false."
  },
  {
    "type": "SELECT",
    "name": "staging",
    "displayName": "Staging",
    "macrosInSelect": true,
    "selectItems": [
      {
        "value": "false",
        "displayValue": "No"
      },
      {
        "value": "true",
        "displayValue": "Yes"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "false",
    "help": "Yes loads Dialog's staging script, which talks to Dialog's staging API. For Dialog's tests only."
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const Object = require('Object');
const addConsentListener = require('addConsentListener');
const copyFromDataLayer = require('copyFromDataLayer');
const createArgumentsQueue = require('createArgumentsQueue');
const getType = require('getType');
const injectScript = require('injectScript');
const isConsentGranted = require('isConsentGranted');
const templateStorage = require('templateStorage');

const PRODUCTION_SCRIPT_URL = 'https://cdn.askdialog.com/assets/dialog.js';
const STAGING_SCRIPT_URL = 'https://d3f72zs8c5zdry.cloudfront.net/assets/dialog.js';
const PRODUCER = 'gtm';
const CONSENT_SET_UP_KEY = 'consentSetUp';
const ANALYTICS_STORAGE = 'analytics_storage';
const CONFIG_COMMAND = 'config';
const CONSENT_COMMAND = 'consent';
const EVENT_COMMAND = 'event';
const CONSENT_GRANTED = 'granted';
const CONSENT_DENIED = 'denied';
const COMMERCE_EVENTS = [
  'view_item_list',
  'view_item',
  'add_to_cart',
  'remove_from_cart',
  'view_cart',
  'begin_checkout',
  'add_shipping_info',
  'add_payment_info',
  'purchase',
];

const dialog = createArgumentsQueue('dialog', 'dialogLayer');

// A variable fed to a Yes/No field can return a boolean or a string.
const isYes = (value) => value === true || value === 'true';

const reportConsent = (granted) => {
  dialog(CONSENT_COMMAND, granted ? CONSENT_GRANTED : CONSENT_DENIED);
};

// templateStorage lives as long as the page: the consent listener goes once.
const setUpConsent = () => {
  if (templateStorage.getItem(CONSENT_SET_UP_KEY) === true) {
    return;
  }
  templateStorage.setItem(CONSENT_SET_UP_KEY, true);
  reportConsent(isConsentGranted(ANALYTICS_STORAGE));
  addConsentListener(ANALYTICS_STORAGE, (type, granted) => {
    reportConsent(granted);
  });
};

// Version 1 reads the last pushed ecommerce, not the model merged with earlier pushes.
const track = (event) => {
  const ecommerce = copyFromDataLayer('ecommerce', 1);
  const parameters = {};
  if (getType(ecommerce) === 'object') {
    Object.keys(ecommerce).forEach((key) => {
      parameters[key] = ecommerce[key];
    });
  }
  parameters.raw = { event: event, ecommerce: ecommerce };
  dialog(EVENT_COMMAND, event, parameters);
};

// Sent on every firing: a variable may give another product after a URL change.
dialog(CONFIG_COMMAND, {
  apiKey: data.apiKey,
  productId: data.productId,
  disableAddToCart: isYes(data.disableAddToCart),
  hideDialog: isYes(data.hideDialog),
  producer: PRODUCER,
});
setUpConsent();
const event = copyFromDataLayer('event');
if (COMMERCE_EVENTS.indexOf(event) !== -1) {
  track(event);
}
const scriptUrl = isYes(data.staging) ? STAGING_SCRIPT_URL : PRODUCTION_SCRIPT_URL;
injectScript(scriptUrl, data.gtmOnSuccess, data.gtmOnFailure, scriptUrl);


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://cdn.askdialog.com/assets/dialog.js"
              },
              {
                "type": 1,
                "string": "https://d3f72zs8c5zdry.cloudfront.net/assets/dialog.js"
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
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedKeys",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "event"
              },
              {
                "type": 1,
                "string": "ecommerce"
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
        "publicId": "access_consent",
        "versionId": "1"
      },
      "param": [
        {
          "key": "consentTypes",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "analytics_storage"
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
        "publicId": "access_globals",
        "versionId": "1"
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
                    "string": "dialog"
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
                    "string": "dialogLayer"
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
        "publicId": "access_template_storage",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Dialog's GTM template (frontend/dialog-tag in dialog-ecom). It loads dialog.js,
which runs the assistant, the product block and the measurement.
Triggers to set on the tag:
- Initialization - All Pages
- History Change
- Custom Event, with "Use regex matching" ticked:
  ^(view_item_list|view_item|add_to_cart|remove_from_cart|view_cart|begin_checkout|add_shipping_info|add_payment_info|purchase)$
Ignored domains and the product block placement are set by Dialog for the store.
