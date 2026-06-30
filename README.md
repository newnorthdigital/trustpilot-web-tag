# Trustpilot — GTM Web Tag Template

A Google Tag Manager web tag template for [Trustpilot](https://www.trustpilot.com) TrustBox widgets and review invitations.

## Features

- **Load TrustBox Widgets** — Inject the Trustpilot bootstrap script that auto-discovers TrustBox widget divs on the page
- **Send Review Invitations** — Trigger review invitation emails on the order confirmation page with customer and order data
- **Product Reviews** — Include product SKUs to trigger product-specific review invitations
- **Debug Mode** — Console logging for troubleshooting

## Setup

### TrustBox Widgets (All Pages)

1. Create a new tag using the **Trustpilot** template
2. Set **Action type** to **Load TrustBox widgets**
3. Set the trigger to **All Pages**
4. Add TrustBox widget divs to your website HTML (from Trustpilot Business app > Integrations > TrustBox)

The bootstrap script automatically discovers all elements with class `trustpilot-widget` and renders them.

### Review Invitations (Order Confirmation)

1. Create a new tag using the **Trustpilot** template
2. Set **Action type** to **Send review invitation**
3. Enter your **Integration Key** (from Trustpilot Business app > Integrations > Ecommerce > JavaScript Integration)
4. Map the order data fields to GTM variables:
   - **Customer Email**: `{{dlv - customer_email}}`
   - **Customer Name**: `{{dlv - customer_name}}`
   - **Order ID**: `{{dlv - order_id}}`
   - **Product SKUs**: `{{dlv - product_skus}}` (optional, comma-separated)
5. Set the trigger to fire on the **Order Confirmation Page**

## Template Fields

### Load TrustBox Widgets
No configuration needed — the bootstrap script handles everything. Just ensure your TrustBox widget divs are in the page HTML.

### Send Review Invitation

| Field | Required | Description |
|-------|----------|-------------|
| Integration Key | Yes | Trustpilot JavaScript integration key |
| Customer Email | Yes | Email address for the review invitation |
| Customer Name | No | Customer's name for personalization |
| Order ID | Yes | Unique order/reference ID |
| Product SKUs | No | Comma-separated SKUs for product reviews |

## Permissions

- **Inject Scripts** — Loads from `widget.trustpilot.com` and `invitejs.trustpilot.com`
- **Access Global Variables** — Read/write `window.tp` for the invitation command queue
- **Logging** — Console logging in debug/preview mode only

## Resources

- [Trustpilot TrustBox Widget Setup](https://support.trustpilot.com/hc/en-us/articles/115011421468)
- [Trustpilot JavaScript Invitation Integration](https://support.trustpilot.com/hc/en-us/articles/115004program)
- [Trustpilot Business App](https://businessapp.b2b.trustpilot.com)

## Author

Created and maintained by [Freek Kampen](https://freekkampen.com) at [New North Digital](https://newnorth.digital?utm_source=github&utm_medium=gtm-template&utm_campaign=trustpilot-web-tag)

## License

Apache 2.0 — see [LICENSE](LICENSE).
