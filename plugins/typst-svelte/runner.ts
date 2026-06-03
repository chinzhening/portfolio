import { spawn } from 'child_process'
import { dirname } from 'path'

const fontPath = process.env.TYPST_FONT_PATH

export function runTypst(args: string[], cwd: string, input?: string): Promise<string> {
    return new Promise((resolve, reject) => {
        const child = spawn('typst', args, { cwd })

        if (input !== undefined) {
            child.stdin.write(input)
        }
        child.stdin.end()

        const chunks: Buffer[] = []
        child.stdout?.on('data', (chunk: Buffer) => {
            chunks.push(chunk)
        })
        child.stderr?.on('data', (data: Buffer) => {
            console.error(`[typst-to-svelte] ${data.toString().trim()}`)
        })

        child.on('close', (code) => {
            if (code !== 0) {
                reject(new Error(`typst exited with code ${code}`))
                return
            }

            resolve(Buffer.concat(chunks).toString('utf8'))
        })

        child.on('error', reject)
    })
}

export function compile(source: string, id: string): Promise<string> {
    return runTypst([
        'compile',
        '--features', 'html',
        '--format', 'html',
        ...(fontPath ? ['--font-path', fontPath] : []),
        '-', '-'
    ], dirname(id), source)
}

export function query(id: string): Promise<any> {
    return runTypst([
        'query',
        '--features', 'html',
        id,
        '<metadata>',
    ], dirname(id)).then((raw) => {
        const results = JSON.parse(raw)
        return results[0].value
    })
}
