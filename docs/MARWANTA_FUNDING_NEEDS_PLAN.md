# MARWANTA Funding Needs Plan
What $5,000-$10,000 is needed for, where every dollar goes, and how the money is
released only against finished work.

    The verdict: yes, the ask is the right size for this stage. MARWANTA needs a small, tightly accounted
    amount to rent real servers, finish the large verification runs the current machine cannot complete, and
    cover fees and basic operating costs. $5,000 keeps the work alive for about six months. $10,000 funds it
    properly for about nine months and adds one independent external review. Anything larger would be
    harder to justify - and harder to raise.

What this money is - and what it is not
   It is testing and infrastructure money: servers, storage, fees, and a capped operating stipend, spent against
   named milestones.
   It is not a token sale, a mainnet launch fund, or a promise of returns. No token, testnet launch date, or profit
   is offered in exchange for this money.
   It is released in tranches. Each part is unlocked only when the previous milestone is finished and checkable
   (see page 5).

Where MARWANTA stands today

MARWANTA is an independent Layer-1 design built around proof-carrying, fault-isolated execution - a different
approach from Ethereum and Solana, not a copy of either. The design phase is complete and frozen; that is the
asset this funding builds on.

          A19                                2                         688,550                                0
          FROZEN                  SAFETY HOLES FOUND                STATES CHECKED IN              PROTOTYPE / TESTNET
      SPECIFICATION                    AND CLOSED                     GAP-TRACE RUN                       BUILT YET
         BASELINE

   Specification frozen (A19). The corrected blueprint and the full decision log are closed as the baseline
   model design.
   Both prefix-safety (IPrefix) holes are closed. The finalisation prefix gate (Option B) was verified: the gap-
   trace run completed clean over 688,550 states, and the consecutive-finalisation proof was re-established -
   blocks h1 and h2 finalise together, in order.
   A complete evidence package exists. Model evidence report, machine-readable evidence file, and a re-
   verified fidelity matrix are ready to package into a public repository.
   Honest limits: three earlier large model families passed but were vacuous for finalisation, so they are not
   presented as safety proof. The NEGATIVE-CONTROL re-run never completed on the current machine - about
   134.6 million states, no violation found, then stalled on disk throughput. Finishing it is a first job this funding
   pays for.

MARWANTA Funding Needs Plan - Page 1 of 6 - Prepared 6 November 2026. All figures in US dollars. Server prices are planning
estimates, not live quotations.
Five things the money is actually needed for

Every line in the budgets on the next page belongs to one of these five needs. If a cost does not fit one of them,
it is not in the plan.

1. Four separate validator servers - the core need
The authorised model configuration uses four validators. Testing crash and network-partition behaviour honestly
requires four physically separate machines: a partition test on one shared machine proves nothing, because the
machines never truly lose sight of each other. The current single virtual machine has already shown its limit - a
large verification run collapsed on disk throughput and could not finish. Four mid-range dedicated servers (8-
core, 64 GB RAM class) are the minimum real test bed.

2. One heavy verification server
Model checking at the scale MARWANTA needs - tens of millions of states - requires a high-memory machine
rented for the large runs: completing the unfinished NEGATIVE-CONTROL run, and re-running the full families
against the frozen A19 specification. This server does the work the current machine physically cannot.

3. Monitoring, storage and backups
One small always-on server for monitoring, logs and a public status view, plus object storage for evidence files,
run logs and backups. Funders and reviewers must be able to see the runs and their results, not just read claims
about them.

4. Fees and setup costs (kharcha-paani around the work)
Domain and email, developer tools, repository and documentation hosting, company or registration fees where a
funder requires a formal entity, accounting for the grant money itself, and small transaction and application fees.
These are small individually, but without them the project cannot receive or account for funding properly.

5. A capped founder operations stipend
The founder works on MARWANTA full-time. A modest, fixed monthly stipend - capped in the budget, named
openly here, and stopped if milestones stop - covers basic living and operating costs so the work continues daily
instead of in spare hours. It is the second-largest line in the recommended budget, and it is deliberately visible:
hiding it would be the fastest way to lose a funder's trust.

    What is deliberately NOT in this budget: no marketing spend, no token launch costs, no exchange
    fees, no team salaries beyond the founder stipend, and no mainnet costs. Those belong to a later stage,
    after a separate founder decision - and they would need their own budget and their own approval.

    Why separate servers cannot be replaced by free tiers: free cloud tiers share one host, throttle disk
    speed, and sleep or stop under load. The unfinished run failed on exactly that disk limit. Cheap but real
    dedicated servers are the lowest honest cost for this work - roughly $55-$120 per machine per month for
    the class needed, based on current public pricing for 8-core / 64 GB dedicated servers.

Two budgets, each adding up exactly

Recommended plan - $10,000 for about 9 months

| Item | Basis | Amount |
|---|---|---:|
| 4 validator servers | About $70/month each x 9 months | $2,520 |
| 1 heavy verification server | About $150/month x 9 months | $1,350 |
| Monitoring / status server | About $30/month x 9 months | $270 |
| Storage and backups | About $25/month x 9 months | $225 |
| Domain, tools and software | Domain, email, dev tools, hosting | $280 |
| Legal, registration and fees | Entity, accounting, application fees | $800 |
| Independent external review | One paid outside review of spec and evidence | $1,500 |
| Founder operations stipend | $200/month x 9 months, capped | $1,800 |
| Demo and application costs | Presentations, travel for meetings | $300 |
| Contingency reserve | Price rises, one server replacement | $955 |
| **Total - recommended plan** | | **$10,000** |

Lean plan - $5,000 for about 6 months

| Item | Basis | Amount |
|---|---|---:|
| 4 validator servers (smaller class) | About $45/month each x 6 months | $1,080 |
| Heavy verification server (burst rental) | About $120/month x 6 months | $720 |
| Monitoring server + storage | About $35/month x 6 months combined | $210 |
| Domain, tools and fees | Essentials only | $550 |
| External review (limited scope) | One narrow review, not full scope | $600 |
| Founder operations stipend | $200/month x 6 months, capped | $1,200 |
| Contingency reserve | Small buffer only | $640 |
| **Total - lean plan** | | **$5,000** |

Server unit prices are planning estimates in the range of current public pricing for this server class, not live quotations; the
contingency line exists precisely because prices move. The lean plan works, but it drops the full external review and leaves
almost no buffer - one price rise or one failed machine eats the reserve.

Money is released only against finished work

No funder should hand over $10,000 on a promise. This plan splits the recommended amount into three
tranches, each unlocked by a deliverable anyone can check.

| Tranche | Amount | Unlocked by |
|---|---|---|
| 1 - Set up and finish the big runs | $3,500 | Available at start. Spent on servers and setup. Reported when: all five servers are live, and the unfinished NEGATIVE-CONTROL run is completed on the heavy server with its full result published. |
| 2 - Prove it on separate machines | $3,500 | Unlocked by Tranche 1 report. Reported when: crash and partition test families are re-run across the four separate validator servers, with logs and evidence published in the public repository. |
| 3 - Independent check and next-step pack | $3,000 | Unlocked by Tranche 2 report. Reported when: the independent external review is delivered, and a written next-step pack states - with costs - what a prototype phase would need, for a separate founder and funder decision. |
| **Total** | **$10,000** | If a tranche's report is not delivered, the next tranche does not start. |

How the chances of funding go up

Funding at this stage is difficult everywhere - most early protocol projects have no finished design at all.
MARWANTA's chances rest on showing finished, checkable work, not on bigger claims. Six actions raise the
odds, in this order:

   1. Publish the repository first. Frozen A19 specification, decision log, evidence report and run traces, in a
   clean public repository. A funder who can verify in ten minutes is worth ten who must take the founder's word.
   2. Lead with the exact budget. This plan - every dollar named, both totals adding up - answers the first
   question every funder asks: where does the money go?
   3. Offer tranches, not a lump sum. Milestone-based release lowers the funder's risk, which is the main
   reason small early asks get refused.
   4. State the limits before the funder finds them. The vacuous early passes, the unfinished run, and the
   absence of a prototype are stated in this plan itself. Funders fund founders whose bad news arrives early.
   5. Apply on several routes in parallel. Ecosystem and research grants, angel investors in blockchain
   infrastructure, and accelerator or hackathon-to-accelerator pipelines. No single route should carry the whole
   plan.
   6. Keep the ask small and specific. $5,000-$10,000 for named testing work is a credible first ask. A large
   round would be refused at this stage and would damage later credibility.

    No guarantee is made. Even with all six actions, funding may take months or may not arrive. This plan
    raises the chances honestly; it does not promise an outcome, a timeline for money, or any return to a
    funder.

What will not be claimed - to anyone

      No testnet or mainnet exists, and no launch date is promised in exchange for funding.
      No token is offered, sold, or implied. Any future token decision is separate and later.
      The model results are bounded checks on an authorised configuration (four validators, limited heights), not a
      general proof for all cases. They are described that way in every application.
      No return, profit, or valuation growth is promised to any funder, grant body, or supporter.
      Prototype work beyond the model phase is not authorised yet. Tranche 3 produces the costed proposal for it -
      the decision itself stays with the founder.

The immediate next steps

  Step       What is done                                                                       Cost

  1          Package the public repository: A19 specification, decision log, evidence           No cost - work only
             package, and this funding plan.

  2          Prepare one short application pack from this plan: two-page summary,               No cost - work only
             budget table, tranche table.

  3          Send the pack in parallel: research and ecosystem grants first, then               Small application fees,
             infrastructure angels, then accelerator pipelines.                                 in budget

  4          On first funding received: order servers, publish the setup, and complete          Tranche 1 - $3,500
             the unfinished verification run (Tranche 1).

The founder's commitment

Every amount received under this plan is spent only on the lines in this budget, reported tranche by tranche, with
server invoices, run logs and the external review published in the repository. If a milestone is not delivered,
spending stops and the funder is told first - before any new request is made to anyone.

That discipline, plus a frozen and machine-checked design that most projects at this stage do not have, is the
real case for funding MARWANTA now: a small amount, exactly accounted, finishing the verification work that
decides whether this Layer-1 deserves its next, larger step.

      Bottom line: $5,000 is the minimum that keeps the work moving for six months. $10,000 is the
      recommended ask - nine months, the large runs finished on real servers, one independent review, and a
      costed next-step pack. The ask is right. The way to raise the chances is not a bigger claim - it is the public
      repository, the exact budget, and the tranches in this plan.

MARWANTA Funding Needs Plan - Page 6 of 6 - End of plan. Prepared 6 November 2026.
