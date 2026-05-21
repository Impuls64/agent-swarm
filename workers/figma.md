# AGENTS — Figma (Design & API)

## Стек

- **Design:** Figma Desktop / Web
- **API:** Figma REST API, Plugin API, Widgets API
- **Automation:** Figma Plugin (JavaScript/TypeScript)

## Commands

```bash
# REST API
curl -X GET "https://api.figma.com/v1/files/YOUR_FILE_KEY" \
  -H "X-Figma-Token: YOUR_ACCESS_TOKEN"

# Plugin development
npm install -g @figma/plugin-typings
```

## REST API Examples

```python
import requests

API_TOKEN = "your_token"
FILE_KEY = "ABC123"

headers = {"X-Figma-Token": API_TOKEN}

# Get file structure
response = requests.get(
    f"https://api.figma.com/v1/files/{FILE_KEY}",
    headers=headers
)
data = response.json()

# Extract components
components = data.get("components", {})
for node_id, component in components.items():
    print(f"Component: {component['name']}")

# Export images
response = requests.get(
    f"https://api.figma.com/v1/images/{FILE_KEY}?ids=1:2,1:3&format=png",
    headers=headers
)
```

## Plugin API

```javascript
figma.showUI(__html__, { width: 400, height: 300 });

// Get selected nodes
const selection = figma.currentPage.selection;

// Create rectangle
const rect = figma.createRectangle();
rect.x = 100;
rect.y = 100;
rect.fills = [{ type: 'SOLID', color: { r: 1, g: 0, b: 0 } }];

figma.currentPage.appendChild(rect);
```

## Design System Structure

```
Design System/
├── 🎨 Colors
│   ├── Primary
│   ├── Secondary
│   └── Neutral
├── 🔤 Typography
│   ├── Heading 1-6
│   ├── Body
│   └── Caption
├── 🧩 Components
│   ├── Buttons
│   ├── Inputs
│   ├── Cards
│   └── Modals
└── 📐 Layout
    ├── Grid
    └── Spacing
```

## Best Practices

- Layer naming: `Component/State/Size`
- Use Frame instead of Group
- Component libraries for team work
- Dev Mode for handoff
- Inspect → CSS / iOS / Android
- Comments for feedback

## Do Not Modify

- Published components without team sync
- Design tokens directly (use Tokens Studio)

## Prohibited

- Hardcoded tokens in plugins
- Nesting > 5 levels deep
- Unused styles and components
- Raster images instead of vectors
- Missing States (hover, active, disabled)

## Integrations

- **Tokens Studio** — design tokens
- **Storybook** — components in code
- **Zeroheight** — documentation
- **Notion** — specs
- **Jira** — tickets from comments
