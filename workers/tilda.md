# AGENTS — Tilda (Website Builder)

## Стек

- **Platform:** Tilda Publishing
- **Editor:** Zero Block, Standard Blocks
- **Integrations:** Webhook, CRM, Forms
- **E-commerce:** Tilda Shop, payment gateways

## Commands

```bash
# No CLI — web-based editor
# Export: Tilda → Export → HTML/JSON
```

## Project Structure

```
my-site.tilda.ws/
├── Главная (Landing)
├── О нас
├── Услуги
├── Портфолио
├── Контакты
└── 404
```

## Zero Block

Professional visual editor:
- Absolute element positioning
- Responsive design (breakpoints)
- Animations and effects
- Layers and grouping

## Webhook Integration

Tilda sends form data to URL:
```json
{
  "Name": "Иван",
  "Email": "ivan@example.com",
  "Phone": "+79991234567",
  "formid": "form123",
  "formname": "Contact Form"
}
```

## SEO

- Title and Description per page
- Alt tags for images
- Human-readable URLs (ЧПУ)
- Schema.org markup
- Sitemap.xml

## Do Not Modify

- Tilda system blocks (CSS restrictions)
- Exported HTML directly (changes lost on re-export)

## Best Practices

- Design in Figma → transfer to Zero Block
- Use components for repeating blocks
- Set analytics goals (Yandex.Metrica, GA)
- Test forms before launch
- Regular backups
- Use custom domain (not tilda.ws)

## Integrations

- **CRM:** Битрикс24, AmoCRM, МойСклад
- **Email:** Mailchimp, UniSender, SendPulse
- **Analytics:** Яндекс.Метрика, Google Analytics
- **Chats:** JivoSite, Talk-Me, VK Messages
- **Payments:** ЮKassa, Robokassa, Stripe

## Prohibited

- Forget mobile adaptation
- Too many animations
- Heavy images (> 500KB)
- Unconfigured 301 redirects
- Missing SSL
