#import "blog/lib.typ": *
#import "blog/colors.typ": muted-colors

#show: article.with(
  title: "Modern Monte Carlo",
  desc: [A deep dive into Monte Carlo methods, modern ideas, and some applications in financial modeling.],
  published: false,
  tags: (
    "finance",
    "monte carlo",
  ),
)

This is a spin-off of my capstone project for undergrad at NUS, supervised by Prof. Ren Weiqing.
It explores Monte Carlo methods and their applications in computational finance; the full report is on my #link("https://www.github.com/chinzhening/capstone-project")[GitHub].

/// Introduction about what the post will explore, can write last.
= Introduction
- State the thesis directly: this post is about variance reduction, and about a pattern — hand-derived structure being replaced by fitted/learned structure — that recurs across the field
- Preview the arc: CV/IS → control functionals → neural control variates → (brief) parallels in NPE and diffusion models
- Be explicit that the NPE/diffusion section is a comparison, not a continuation — set that expectation early so it doesn't feel like scope creep later
- End with pointer to the lineage diagram
- Write this section LAST
- Capstone credit line stays separate/small, above this section

= Preliminaries
- Define plain MC estimator + CLT-based error; show O(1/√n) rate, dimension-free but constant-heavy
- Name the constant: Var_p[f(x)] — this is the thing every subsequent method attacks
- Brief rare-event example to make the constant concrete: estimating P(f(x) > threshold) when the event is rare under p wastes almost all samples, relative error explodes even though the O(1/√n) rate "looks fine" on paper
- Frame "structure" plainly here: any extra fact about p or f that lets you beat the naive constant
- Figure: log-log error vs. n plot
- Figure: naive MC sample cloud missing a rare/important region

= Variance Reduction Techniques
Both control variates and importance sampling attack the same quantity, the
$"Var"_p [f(X)]$ constant in front of the $O(n^(-1\/2))$ rate. Neither changes
the rate, but they can reduce the constant significantly by exploiting the
geometry of the problem. Control variates introduce a function $g(X)$ correlated
with $f(X)$, and importance sampling introduces a new distribution $q$ that is
more concentrated on the important regions of the domain. But these have to be
supplied by the user, and may not be easily availble.

== Control Variates
Suppose we want $mu = EE_p [f(X)]$, we have access to some function $h(X)$ whose
expectation $EE_p [h(X)] = v$ is known. For any $beta in RR$, define the estimator
$
  hat(mu)_beta = 1/n sum_(i=1)^n [f(X_i) - beta(h(X_i) - v)].
$
This is unbiased for any $beta$, since $EE_p [h(X) - v] = 0$ and the variance is
$
  "Var"_p [hat(mu)_beta] = 1/n ("Var"[f(X)] - 2 beta "Cov"(f(X), h(X)) + beta^2 "Var"[h(X)]).
$
This is a quadratic in $beta$, which is minimized at
$
  beta^* = "Cov"(f(X), h(X)) / "Var"[h(X)].
$
Substituting this back into the estimator variance gives the minimum achievable variance
$
  "Var"_p [hat(mu)_(beta^*)] = 1/n "Var"[f(X)] (1 - rho^2)
$
where $rho$ is the correlation coefficient between $f(X)$ and $h(X)$.
The more correlated they are, the better the variance reduction.
But the catch is that you must find an $h$ that is well correlated with $f$ with
a known closed form expectation. If $rho -> 0$, then the variance reduction is negligible, and if $rho -> 1$, then the variance reduction is significant.
 
#figure(
  caption: [Variance comparison (naive MC vs. control variate vs. importance sampling) on the same toy integral, log-scale y-axis, showing convergence of the running estimate over $n$.]
)[
  #import "@preview/lilaq:0.6.0" as lq

  #show: lq.set-diagram(width: 8cm, height: 5cm)

  #let x = (1e2, 1e3, 1e4, 1e5)
  #let naive = (3.25e-2, 1e-2, 3.1e-3, 1e-3)
  #let cv = naive.map(x => x * 0.4 + 0.1e-3)
  #let is-mc = naive.map(x => x * 0.1 - 0.1e-4)

  #lq.diagram(
    legend: (position: top + right),
    xlim: (50, 5e5),
    ylim: (3.1e-5, 1e-1),
    xaxis: (label: $n$, scale: "log"),
    yaxis: (label: "Error", scale: "log"),  
    lq.plot(x, naive, label: "Naive", yerr: naive.map(x => x * 0.3), stroke: (dash: "dashed"), color: muted-colors.dark-blue),
    lq.plot(x, cv, label: "CV", yerr: cv.map(x => x * 0.3), stroke: (dash: "dashed"), color: muted-colors.dark-orange),
    lq.plot(x, is-mc, label: "IS", yerr: is-mc.map(x => x * 0.3), stroke: (dash: "dashed"), color: muted-colors.dark-green),
  )
]

Intuitively, $h(X)$ "explains" a portion of the variability in $f(X)$.

== Importance Sampling
Instead of correcting the estimator post-hoc, importance sampling alters the
sampling distribution itself, rewriting the target expectation as
$
  mu = EE_p [f(X)] = integral f(x) p(x) dif x = integral f(x) p(x)/q(x) dot.c q(x) dif x = EE_q [f(X) p(X)/q(X)],
$
for any $q$ with $"supp"(p) subset.eq "supp"(q)$. Sampling $X_i tilde q$ and
averaging the weighted quantity $w(X_i) = p(X_i)\/q(X_i)$ gives an unbiased estimator
with variance
$
  "Var"_q [f(X) w(X)] = EE_q [f(X)^2 w(X)^2] - mu^2
$
The choice of $q$ is problem-dependent and also limited because $q$
must have heavier tails than $p$ in regions where $f$ is significant. Otherwise,
$w(x) = p(x) \/ q(x)$ blows up exactly where $f(x) w(x)$ is evaluated and a small
number of samples can dominate the entire estimate, inflating the variance.
This problem is known as "weight degeneracy" and is a common issue in importance sampling:
pick a bad $q$ and you get a noisier estimate.

Take the rare-event problem from before: estimating $PP(Z > 2)$ where $Z$ follows $p = N(0, 1)$.
Using a tilted normal distribution $q = N(2, 1)$ as the proposal distribution,
we can sample from $q$ and weight the samples by $w(x) = p(x)\/q(x)$ to get a
much better estimate of the rare event probability.
But if we are estimating $PP(|Z| > 2)$ instead, then the left-tail sample weights explode,
and the estimate is worse off.

#figure(
  caption: [Importance sampling with a well-chosen $q$ vs. a bad $q$, showing the density of the target distribution $p$ and the proposal distribution $q$, as well as the samples drawn from $q$ and their weights $w(x) = p(x)\/q(x)$.]
)[  
  #import "@preview/lilaq:0.6.0" as lq
  #import "@preview/suiji:0.5.1" as sj

  #show: lq.set-diagram(width: 6cm, height: 4cm)

  #let rng = sj.gen-rng-f(42)

  #let normal-pdf(x, center, scale) = calc.exp(-calc.pow(x - center, 2) / (2 * calc.pow(scale, 2))) / (scale * calc.sqrt(2 * calc.pi))

  #let x = lq.linspace(-4, 6)

  #let (rng, samples) = sj.normal-f(
    rng,
    loc: 0,
    scale: 1,
    size: 500,
  )

  #let left-region = samples.filter(x => x < -2)
  #let right-region = samples.filter(x => x > 2)

  #let p = x.map(x => normal-pdf(x, 0, 1))
  #let q = x.map(x => normal-pdf(x, 2, 1))
  #let w = range(0, x.len()).map(i => p.at(i) / q.at(i))

  #let l = lq.linspace(-4, -2)
  #let r = lq.linspace(2, 4)

  #table(columns: 2,
    /// Well-chosen q
    lq.diagram(
      xaxis: (label: $x$),
      yaxis: (label: "Density"),  
      lq.plot(x, p, label: $p(x)$, color: muted-colors.dark-blue, mark: none),
      lq.plot(x, q, label: $q(x)$, color: muted-colors.dark-orange, mark: none),
      lq.fill-between(
        r,
        r.map(x => normal-pdf(x, 0, 1)),
        y2: r.map(x => 0),
        fill: muted-colors.dark-blue.lighten(50%),
      ),
      lq.plot(
        right-region, (0.0,) * right-region.len(),
        stroke: none,
        color: muted-colors.dark-blue.transparentize(10%),
      )
    ),
    /// Bad case
    lq.diagram(
      legend: (position: top + right),
      xaxis: (label: $x$),
      yaxis: (label: "Density"),  
      lq.plot(x, p, label: $p(x)$, color: muted-colors.dark-blue, mark: none),
      lq.plot(x, q, label: $q(x)$, color: muted-colors.dark-orange, mark: none),
      lq.fill-between(
        l,
        l.map(x => normal-pdf(x, 0, 1)),
        y2: l.map(x => 0),
        fill: muted-colors.dark-blue.lighten(50%),
      ),
      lq.fill-between(
        r,
        r.map(x => normal-pdf(x, 0, 1)),
        y2: r.map(x => 0),
        fill: muted-colors.dark-blue.lighten(50%),
      ),
      lq.plot(
        right-region, (0.0,) * right-region.len(),
        stroke: none,
        color: muted-colors.dark-blue.transparentize(10%),
      ),
      lq.plot(
        left-region, (0.0,) * left-region.len(),
        stroke: none,
        color: muted-colors.dark-red.transparentize(10%),
      )
    ),
  )
]

== The Common Limitation
Neither control variates nor importance sampling are systematic: both depend
heavily on problem geometry. A good control variate for one integrand $f$ may
be useless for another; a good proposal $q$ for one target $p$ may fail
entirely if $p$ changes. There is no procedure for finding $h$ or $q$, only
intuition, problem-specific tricks (e.g. Taylor-expand $f$ around a mode,
exploit a known conjugate structure), and trial and error.

Consider what a good $h$ requires: $"Cov"(f(X), h(X))$ large, but $E[h(X)]$
known in closed form. These pull in opposite directions, since functions
expressive enough to correlate with an arbitrary $f$ rarely have tractable
expectations under $p$. The practitioner searches a small, hand-curated
library (polynomials, sufficient statistics, low-order moments) for something
that works, and when $f$ is high-dimensional or unfamiliar, the search often
comes up empty.

Importance sampling has the same disease in a different guise. The optimal
proposal $q^*$ depends on $f$ itself, so any $q$ fixed in advance is a guess,
and mismatches between $q$ and $p$ compound badly in high dimensions: the
estimator's variance scales with the $chi^2$-divergence between $q$ and $p$,
which grows fast with dimension unless $q$ tracks $p$'s geometry closely. A
proposal that looks fine in two dimensions can give infinite variance in
twenty.

#side-note[
  The variance-optimal proposal is $q^* prop |f(x)| p(x)$; fitting a parametric
  family $q_theta$ to approximate it by minimizing
  $"KL"(q_theta || q^*)$ over $theta$ is known as the *cross-entropy method*,
  an early instance of "fit a proposal" thinking, limited by the same problem:
  it requires choosing $q_theta$'s family $Q = {q_theta: theta in Theta}$
  ahead of time.
]

#figure(
  caption: [Minimizing $"KL"(q_theta || q^*)$ over a one-dimensional $theta$
  showing the objective function and the optimal $theta^*$ where the minimum occurs.]
)[
  #import "@preview/lilaq:0.6.0" as lq

  #show: lq.set-diagram(width: 8cm, height: 5cm)

  #let objective-function(theta) = 1.25 - calc.exp(-calc.pow(theta - 1, 2) / 2) - calc.exp(-calc.pow(theta - 4, 2) / 2) / 1.5

  #let thetas = lq.linspace(-4, 12, num: 100)
  #let kl = thetas.map(objective-function)
  #let near-zeros = thetas.map(x => 0.1)

  #lq.diagram(
    legend: (position: top + right),
    xlim: (-4, 12),
    ylim: (-0.01, 1.5),
    xaxis: (label: $theta$),
    yaxis: (label: $"KL"(q^*||q_theta)$),
    lq.plot(thetas, kl, color: muted-colors.dark-blue, mark: none),
    lq.plot(thetas, near-zeros, label: [$q^*$-err], color: muted-colors.red, mark: none, stroke: (dash: "dashed")),
    lq.plot((1,), (0.25,), label: $q_(theta^*)$, color: muted-colors.dark-red, mark: "star", stroke: none)
  )
]

Both techniques ask the practitioner to solve an implicit
optimization problem: search a space of functions (or distributions) for the
best-fit member to a target ($f$, or $q^*$). This
doesn't scale. It demands a fresh derivation per $(f, p)$ pair, with no
guarantee a good choice lies within reach of intuition.

This is the structural weakness that motivates everything that follows.
If the problem is really a search over function space, the fix is to make that search
explicit: parameterize the space flexibly, define a loss whose minimum is
the optimal $h$ or $q$, and let an algorithm search instead of
intuition. The question is not whether a good $h$ or $q$ exists (it typically
does) but whether it can be recovered *systematically*.

= Regression and Kernel Methods

The first move away from hand-picking $h$ is the smallest one possible: keep
the *form* of $h$ fixed and fit only its coefficients. Suppose we posit a
linear combination $h(x) = sum_(i=1)^m beta_i phi_i (x)$ over a fixed basis
${phi_i}$ with known expectations $E_p [phi_i (X)] = mu_i$ (monomials,
Fourier features, whatever is tractable). The control variate estimator
becomes

$ hat(I) = 1/n sum_(j=1)^n f(x_j) - sum_(i=1)^m beta_i (phi_i (x_j) - mu_i) $

and the optimal $beta$ is exactly the population least-squares regression
coefficient of $f$ onto ${phi_i - mu_i}$ under $p$. In finite samples, this is
ordinary least squares: regress $f(x_j)$ on the centered basis evaluations and
read off $hat(beta)$. This is the first real step from "guess $h$" toward "fit
$h$": the functional form is still chosen by hand, but the coefficients that
determine how much each basis function contributes are now the output of a
well-posed optimization problem, with a closed-form solution and a
well-understood bias-variance tradeoff governed by $m$.

The obvious question is how far this can be pushed. A fixed low-order
polynomial basis captures only what a low-order polynomial can capture; if $f$
has structure at a scale the basis doesn't see, no choice of $beta$ fixes that.
What's needed is a basis rich enough to approximate essentially any $f$, paired
with a way to compute $mu_i$ for every basis element without hand-deriving an
integral each time. Stein's identity supplies exactly this.

== Stein's Identity and Control Functionals

For a smooth target density $p$ on $RR^d$ and a vector-valued function
$h: RR^d -> RR^d$ satisfying mild boundary conditions (decay of $p(x) h(x)$ at
the domain's boundary), integration by parts gives

$ E_p [nabla log p(X) dot h(X) + nabla dot h(X)] = 0 $

The term $nabla log p(x)$ is the *score function* of $p$: a quantity that
depends only on $p$, not on any particular integrand $f$. What Stein's
identity buys us is a mechanical way to generate an entire function class,
every member of which has known expectation zero, from a single ingredient (the
score) computed once. Contrast this with the earlier setting, where each new
basis function $phi_i$ needed its own hand-derived $mu_i$: here, apply the
Stein operator $cal(T)_p h := nabla log p dot h + nabla dot h$ to *any*
smooth $h$, and the result integrates to zero under $p$ automatically.

#side-note[
  This is the crucial shift in the level of automation. We have not automated
  away the need to know $p$ analytically well enough to compute $nabla log p$;
  we have automated away the need to hand-verify $E_p [h] = mu$ for every
  candidate function separately. The score is derived once, and the Stein
  operator turns it into a generating machine for zero-mean functions.
]

The remaining task is to choose $h$ richly enough to correlate well with $f$.
Take a reproducing kernel Hilbert space (RKHS) $cal(H)_k$ with a base kernel
$k(x, x')$, e.g. the RBF kernel $k(x,x') = exp(-norm(x-x')^2 / (2ell^2))$, and
apply the Stein operator to its feature map. This produces the _Stein kernel_

$ k_p (x, x') = nabla_x log p(x) dot nabla_(x') log p(x') dot k(x,x')
  + nabla_x log p(x) dot nabla_(x') k(x,x')
  + nabla_(x') log p(x') dot nabla_x k(x,x')
  + "tr"(nabla_x nabla_(x') k(x,x')) $

Every function in the RKHS induced by $k_p$ has expectation exactly zero under
$p$, by construction, for any bandwidth $ell$ and any smooth base kernel. This
is a _reproducing kernel Stein discrepancy_ construction: the base kernel
supplies flexibility (universal approximation as $ell$ varies and $m$ grows),
and the Stein operator supplies the zero-mean guarantee for free.

#figure(
  caption:[Diagram: base RBF kernel $k(x,x')$ on the left, Stein operator $cal(T)_p$
  applied via $nabla log p$ in the middle, Stein kernel $k_p (x,x')$ on the
  right. Annotate the operator arrow with "requires $nabla log p$ in closed
  form."
])[
  placeholder
]

== Fitting the Control Functional

With the Stein kernel in hand, we posit $h(x) = sum_(j=1)^n beta_j k_p (x,
x_j)$ over the same sample used for estimation (or a held-out design set), and
solve for $beta$ by ridge-regularized least squares:

$ hat(beta) = (K_p + lambda I)^(-1) f $

where $K_p$ is the $n times n$ Gram matrix with entries $(K_p)_(i j) = k_p (x_i,
x_j)$, $f$ is the vector of integrand evaluations, and $lambda > 0$ is a
ridge penalty controlling overfitting to sample noise. The fitted control
variate $hat(h)(x) = sum_j hat(beta)_j k_p (x, x_j)$ has known (zero)
expectation under $p$ term-by-term, so the resulting estimator

$ hat(I) = 1/n sum_(j=1)^n [f(x_j) - hat(h)(x_j)] $

remains unbiased for any $lambda$, with $lambda$ trading off residual variance
against stability of the fit. This is the *control functional* estimator: the
function class is now large enough (an RKHS, dense in a broad class of
functions under mild conditions on $k$) that fitting $beta$ by regression can
approximate the ideal control variate $h^* approx f - E_p [f]$ arbitrarily well,
as $n$ grows and $ell$, $lambda$ are tuned appropriately.

#figure(
  caption:[Plot: toy 1-D integrand $f(x)$ overlaid with fitted control functional
  $hat(h)(x)$ on the same axes; residual $f(x) - hat(h)(x)$ shown below,
  visibly flatter and smaller in magnitude than $f$ itself.
])[
  placeholder
]

#side-note[
  In practice $lambda$ and $ell$ are chosen by cross-validation on the same
  sample, minimizing the estimated variance of $hat(I)$ directly rather than a
  generic predictive loss, since the quantity we actually care about is the
  variance of the residual under $p$, not pointwise regression accuracy.
]

== What Has and Hasn't Been Automated

It is worth being precise about what this machinery buys, because it is easy
to overstate. Control functionals automate the search over *function shape*
within a rich class, replacing hand-picked basis functions with a
data-driven fit over an RKHS. What they do not automate is the analytic
prerequisite the whole construction rests on: $nabla log p(x)$ must be
available in closed form to build $k_p$ at all. If $p$ is known only up to
simulation (no tractable density), or its log-density is not differentiable in
closed form, the Stein kernel cannot be constructed, and this method offers no
recourse.

So the ledger so far: the coefficients of $h$ are fit automatically; the shape
of $h$ is now flexible enough that a good approximation to $h^*$ typically
exists in reach of the fit; but the object the entire construction is built
from, the score $nabla log p$, is still handed to the method, not discovered
by it. Whatever comes next has to either relax this requirement or accept it
and push the automation further within it.

Cost of the fit is $O(n^3)$ for the matrix inversion, which is a practical limit on
the sample size $n$ for which this method is feasible. There are
approximate methods to reduce this cost, e.g. low-rank approximations to the
Gram matrix, but they incur bias.

= Neural Networks

An RKHS is still a *linear* space. The natural next step drops linearity
entirely: parameterize $h_theta$ as a neural network and fit $theta$ by
gradient descent directly on the estimator's variance @wan2019neural @si2021gradient,

$ cal(L)(theta) = "Var"_p [f(X) - cal(T)_p h_theta (X)]
  approx 1/n sum_j (f(x_j) - cal(T)_p h_theta (x_j) - macron(r))^2 $

Because $cal(T)_p h_theta$ has zero expectation under $p$ for *any* $theta$
(Stein's identity again), gradient descent can chase variance alone without
ever risking correctness — structural unbiasedness, optimized quality. This
separation is what makes the whole ladder work.

#figure(
  caption: [Estimated variance of $hat(I)$ (log scale) vs. gradient step: monotonic-ish
  decrease, plateau at network capacity.
])[
  placeholder
]

#side-note[
  The network is typically trained on a design sample separate from the one
  used to report $hat(I)$, to avoid overfitting $h_theta$ to the specific
  noise realization of the evaluation sample.
]

What changed: $h$ is fit end-to-end over a much larger, nonlinear parameter
space instead of built from a fixed kernel and a closed-form solve. What
hasn't: $p$ is still assumed known well enough to sample from and compute
$nabla log p$, and $h$ is still a correction sitting on top of direct sampling
from $p$. This is the last rung of the variance-reduction ladder proper —
nothing here touches the *sampling* side. That question is the return to
importance sampling.

#figure(
  caption: [Same toy integrand as above, RKHS-fitted and neural-fitted $cal(T)_p
  h_theta(x)$ overlaid, shared residual panel comparing both traces.
])[
  placeholder
]

= Parametric Families and Normalizing Flows

The cross-entropy method fits $q_theta$ to $q^* prop |f(x)| p(x)$ by
minimizing $"KL"(q_theta || q^*)$ @rubinstein1997, but the fit is only as good
as the family's capacity: a Gaussian or small mixture is a poor match whenever
$q^*$ is multimodal, skewed, or heavy-tailed in ways the family can't express.
Normalizing flows @rezende2015 @papamakarios2021 replace the restrictive
family with a composition of invertible, differentiable transforms
$T_theta: RR^d -> RR^d$ pushing forward a simple base $q_0$:

$ q_theta (x) = q_0 (T_theta^(-1)(x)) dot abs(det J_(T_theta^(-1))(x)) $

Layers are chosen so both $T_theta$ and its Jacobian determinant are cheap,
giving *both* a tractable density (for importance weights $p(x)\/q_theta (x)$)
and cheap exact sampling — the combination generic flexible density
estimators rarely offer.

#figure(
  caption: [ Base $q_0$ $arrow.r$ composed invertible layers $T_theta$ $arrow.r$
  transformed $q_theta$; arrows for both sampling (forward) and density
  evaluation (inverse) directions.
])[
  placeholder
]

Fitting proceeds as cross-entropy prescribes, but now the family can matter:
minimize $"KL"(q_theta || q^*)$, i.e. the cross-entropy
$cal(L)(theta) = -EE_(q^*)[log q_theta(X)]$, estimated via self-normalized
importance sampling or an adaptive sample/update scheme, with gradients
backpropagated directly since $q_theta(x)$ is closed-form.

#side-note[
  Minimizing the reverse KL, $"KL"(q_theta || p)$ @rezende2015, needs only
  $p$ up to a normalizing constant and samples from $q_theta$ itself, but is
  mode-seeking: the fitted $q_theta$ can ignore minor modes of $q^*$ entirely.
]

#figure(
  caption: [Toy multimodal $q^*(x)$ overlaid with (a) fitted single-Gaussian
  cross-entropy proposal, (b) fitted flow proposal tracking the extra mode.
])[
  placeholder
]

The ledger, once more: the proposal's shape is no longer a hand-picked family
with a handful of parameters, and fitting is a standard gradient-descent
problem. But we still need $p(x)$ evaluable up to a normalizing constant to
form weights or compute $q^*$, and $f$, $p$ remain given, fixed, and
evaluable, the same assumption every method here has made from the first
control variate.
= Similarities in Other Fields

= Application:


#bibliography(
  "references.bib",
  title: "References",
)