# AGENTS — Frontend (React 18+ / TypeScript / Vite)

## Стек

- **Framework:** React 18+ (functional components)
- **Language:** TypeScript (strict mode)
- **Bundler:** Vite / Next.js
- **Styling:** Tailwind CSS / CSS Modules
- **State:** React Query (TanStack) / Zustand / Redux Toolkit
- **Forms:** React Hook Form + Zod
- **Tests:** Vitest + React Testing Library

## Commands

```bash
# Development
npm run dev              # Local dev server (port 3000)
npm run build            # Production build

# Testing
npm run test             # Run all tests
npm run test -- --run    # Run once (CI)
npm run test -- src/components/Button.test.tsx  # Single file

# Quality
npm run lint             # ESLint
npm run format           # Prettier
npm run typecheck        # TypeScript check
```

## Project Structure

```
src/
├── components/          # Reusable UI components
│   ├── ui/              # Base (Button, Input, Modal)
│   └── layout/          # Layout, Header, Sidebar
├── features/            # Business features (auth, cart)
├── hooks/               # Custom React hooks
├── lib/                 # Utilities, API client
├── types/               # Global TypeScript types
├── store/               # State management
└── pages/               # Pages (Next.js) or routes
```

## Code Style

```typescript
// ✅ Good: explicit interface, functional component, destructuring
interface ButtonProps {
  variant: 'primary' | 'secondary';
  onClick: () => void;
  children: React.ReactNode;
  disabled?: boolean;
}

export const Button: React.FC<ButtonProps> = ({
  variant,
  onClick,
  children,
  disabled = false,
}) => {
  return (
    <button
      className={cn('btn', `btn-${variant}`)}
      onClick={onClick}
      disabled={disabled}
      type="button"
    >
      {children}
    </button>
  );
};

// ❌ Bad: implicit any, class component, no types
class MyButton extends React.Component {
  render() {
    return <button onClick={this.props.onClick}>{this.props.children}</button>;
  }
}
```

- Prettier + ESLint (strict config)
- Functional components, max 200 lines
- Props interfaces at top of file
- Custom hooks in separate files (`useAuth.ts`)
- 2 spaces indent
- ≤ 88 characters per line

## Testing

```bash
npm run test
npm run test -- --coverage
```

- Vitest + React Testing Library
- Test behavior, not implementation
- Mock API layer (MSW)
- AAA pattern (Arrange, Act, Assert)
- Coverage > 80% for new components

## React Patterns

```typescript
// ✅ Good: custom hook for reusable logic
function useAuth() {
  const { data: user, isLoading } = useQuery({
    queryKey: ['user'],
    queryFn: fetchUser,
  });
  
  const logout = useCallback(() => {
    localStorage.removeItem('token');
    queryClient.invalidateQueries({ queryKey: ['user'] });
  }, []);
  
  return { user, isLoading, logout };
}

// ✅ Good: lazy loading + Suspense
const Dashboard = React.lazy(() => import('./pages/Dashboard'));

function App() {
  return (
    <Suspense fallback={<Loading />}>
      <Dashboard />
    </Suspense>
  );
}
```

- DRY, but readability > cleverness
- Custom hooks for reusable logic
- `useMemo`, `useCallback` — only when needed
- `React.lazy()` + `Suspense` for code splitting
- Error Boundaries for error handling
- Always `key` prop for lists
- Destructure props

## Do Not Modify

- `.env` — secrets
- `package-lock.json` / `yarn.lock` — only via package manager
- `public/` — static assets, managed separately
- `dist/` / `build/` — auto-generated
- Component libraries in `node_modules/`

## Prohibited

- `any` without comment
- Mutating props
- `console.log` in production
- Synchronous requests in `useEffect`
- Using `index` as `key` for dynamic lists
- Prop drilling deeper than 2 levels
