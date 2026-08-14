import { spawn } from 'child_process';
import { dirname } from 'path';

import { readMetadata, type MetadataResult } from './metadata.ts';

const fontPath = process.env.TYPST_FONT_PATH;

function runTypst(args: string[], cwd: string, input?: string): Promise<string> {
    return new Promise((resolve, reject) => {
        const child = spawn('typst', args, { cwd });

        if (input !== undefined) {
            child.stdin.write(input);
        }
        child.stdin.end();

        const chunks: Buffer[] = [];
        child.stdout?.on('data', (chunk: Buffer) => {
            chunks.push(chunk);
        });
        child.stderr?.on('data', (data: Buffer) => {
            console.error(`[typst-to-svelte] ${data.toString().trim()}`);
        });

        child.on('close', (code) => {
            if (code !== 0) {
                reject(new Error(`typst exited with code ${code}`));
                return;
            }

            resolve(Buffer.concat(chunks).toString('utf8'));
        });

        child.on('error', reject);
    });
}

export function compile(source: string, id: string): Promise<string> {
    return runTypst(
        [
            'compile',
            '--features',
            'html',
            '--format',
            'html',
            ...(fontPath ? ['--font-path', fontPath] : []),
            '-',
            '-'
        ],
        dirname(id),
        source
    );
}

export function query<M>(id: string): Promise<MetadataResult<M>> {
    return runTypst(
        ['eval', 'query(<metadata>)', '--features', 'html', '--in', id],
        dirname(id)
    ).then((raw) => readMetadata<M>(raw, id));
}
