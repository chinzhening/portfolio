export type TypstNode =
    | { kind: 'html'; html: string }
    | { kind: 'element'; tag: string; attrs: Record<string, string>; children: TypstNode[] }
    | {
          kind: 'component';
          name: string;
          props: Record<string, unknown>;
          slots?: Record<string, TypstNode[]>;
          children: TypstNode[];
      }
    | { kind: 'code'; id: string; lang: string; source: string; highlighted?: string };

export interface TypstDocument<M = unknown> {
    metadata: M;
    children: TypstNode[];
}
