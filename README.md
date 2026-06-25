# Northwind Mutual — Compliance-Governed Infrastructure as Code

Terraform + Azure DevOps + Azure Policy, provisioning and governing the base
infrastructure for a fictional insurance claims-processing workload.

> **Disclaimer:** "Northwind Mutual" is a fictional company. All infrastructure,
> naming, and configuration in this project are for personal learning purposes
> only and do not represent or use any real systems, data, or processes from
> any actual insurance company or employer.

---

## What this project demonstrates

Anyone can write Terraform to create a virtual machine. The harder, more
valuable skill is *governing* infrastructure so it can't be created in a
non-compliant way in the first place. This project provisions a small set of
Azure resources (a virtual network, a virtual machine, and a storage account)
using Terraform, deployed through Azure DevOps pipelines with a human approval
gate between plan and apply — and enforces an Azure Policy compliance
initiative on top, modeled on real constraints a Canadian insurer would care
about: data residency, encryption, audit tagging, and network exposure.

*(Sections below will be filled in as the project is built, commit by commit.)*

## Architecture

_(diagram + description — added in a later commit)_

## Infrastructure provisioned

_(added in Stage 2)_

## The compliance initiative

_(added in Stage 5 — the centerpiece of this project)_

## CI/CD pipelines

_(added in Stages 4 and 6)_

## Cost-conscious design

_(added at project completion)_

## What a production setup would add

_(deliberately deferred items — added at project completion)_