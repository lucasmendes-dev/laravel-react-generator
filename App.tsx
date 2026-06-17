interface AppProps {
    name?: string
}

export default function App() {
    const raw = document.getElementById('app')?.dataset.props ?? '{}'
    const props: AppProps = JSON.parse(raw)

    return (
        <div>
            <h1>Hello from React</h1>
        </div>
    )
}
