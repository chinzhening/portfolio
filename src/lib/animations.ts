import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { prefersReducedMotion } from 'svelte/motion';

gsap.registerPlugin(ScrollTrigger);

type AnimationType = keyof typeof gsap;
export interface AnimationOptions extends GSAPTweenVars {
    type: AnimationType;
    scrollTrigger?: ScrollTrigger.Vars;
}

export function animate(
    node: HTMLElement,
    { type, scrollTrigger, ...args }: AnimationOptions
): { destroy?: () => void } {
    if (prefersReducedMotion.current) return {};

    const method = gsap[type] as
        ((target: gsap.TweenTarget, vars: GSAPTweenVars) => GSAPTween) | undefined;

    if (!method) {
        console.warn(`GSAP method "${type}" does not exist.`);
        return {};
    }

    const tween = method(node, {
        ...args,
        scrollTrigger: scrollTrigger
            ? {
                  ...scrollTrigger,
                  trigger: scrollTrigger.trigger || node
              }
            : undefined
    });

    return {
        destroy() {
            // kill the animation
            tween.kill();

            // kill the scroll trigger if it exists
            if (scrollTrigger && tween.scrollTrigger) {
                tween.scrollTrigger.kill();
            }
        }
    };
}

export function fadeIn(
    direction: 'up' | 'down' | 'left' | 'right' | 'static' = 'up'
): AnimationOptions {
    const options: AnimationOptions = {
        type: 'from',
        opacity: 0.25,
        duration: 0.9,
        scrollTrigger: {
            start: 'top 80%',
            end: 'bottom 60%',
            toggleActions: 'play none none'
        }
    };
    const distance = 25;
    return {
        ...options,
        ...(direction === 'up' && { y: distance }),
        ...(direction === 'down' && { y: -distance }),
        ...(direction === 'left' && { x: distance }),
        ...(direction === 'right' && { x: -distance }),
        ...(direction === 'static' && { y: 0 })
    };
}

export const fadeUp: AnimationOptions = {
    type: 'from',
    y: 25,
    opacity: 0.3,
    duration: 0.7,
    scrollTrigger: {
        start: 'top 80%',
        end: 'bottom 60%',
        toggleActions: 'play none none'
    }
};

export const down: AnimationOptions = {
    type: 'from',
    y: -20,
    duration: 0.7,
    scrollTrigger: {
        start: 'top 80%',
        end: 'bottom 60%',
        toggleActions: 'play none none'
    }
};
