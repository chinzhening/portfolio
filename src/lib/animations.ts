import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

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
    const method = gsap[type] as
        | ((target: gsap.TweenTarget, vars: GSAPTweenVars) => GSAPTween)
        | undefined;
    
    if (!method) {
        console.warn(`GSAP method "${type}" does not exist.`);
        return {};
    }

    const tween = method(node, {
        ...args,
        scrollTrigger: scrollTrigger
            ? {
                ...scrollTrigger,
                trigger: scrollTrigger.trigger || node,
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

export function fadeIn(direction: 'up' | 'down' | 'left' | 'right' = 'up'): AnimationOptions {
    const options: AnimationOptions = {
        type: 'from',
        opacity: 0,
        duration: .7,
        scrollTrigger: {
            start: "top 80%",
            end: "bottom 60%",
            toggleActions: "play none none"
        }
    };
    return {
        ...options,
        ...(direction === 'up' && { y: 50 }),
        ...(direction === 'down' && { y: -50 }),
        ...(direction === 'left' && { x: 50 }),
        ...(direction === 'right' && { x: -50 })
    };
}

export const fadeUp: AnimationOptions = {
    type: 'from',
    y: 50,
    opacity: 0,
    duration: .7,
    scrollTrigger: {
        start: "top 80%",
        end: "bottom 60%",
        toggleActions: "play none none"
    }
};

export const down: AnimationOptions = {
    type: 'from',
    y: -20,
    duration: .7,
    scrollTrigger: {
        start: "top 80%",
        end: "bottom 60%",
        toggleActions: "play none none"
    }
};
