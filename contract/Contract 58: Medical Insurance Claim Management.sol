// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

///////////////////////////////////////////////////////////////
// Project Title: Medical Insurance Claim Management
//
// Project Description:
// The Medical Insurance Claim Management system is designed to
// streamline the process of submitting, reviewing, and managing
// medical insurance claims using blockchain technology. This
// smart contract-based application enables individuals to submit
// their insurance claims, track the status of their claims, and
// allows the insurance provider to approve or reject claims,
// ensuring a transparent and tamper-proof claims process.
//
// Project Vision:
// The vision of the Medical Insurance Claim Management system is to
// modernize the healthcare insurance claims process by eliminating
// inefficiencies, reducing fraud, and ensuring transparency in the
// claims process. This system is built on blockchain technology to
// ensure that all interactions with the system are secure and
// transparent, fostering trust between policyholders and insurance
// providers.
//
// Key Features:
// - Claim Submission: Users can submit medical insurance claims through
//   the system, including claim amount and a description of the medical event.
// - Claim Approval/Rejection: An admin (insurance provider) can review and
//   either approve or reject claims based on provided criteria.
// - Claim Tracking: Users can track the status of their claims (Pending, Approved, Rejected).
// - Transparency: All claim details are recorded on the blockchain,
//   ensuring tamper-proof records.
// - Security: Blockchain ensures that data cannot be modified once entered,
//   reducing the chances of fraud or manipulation.
// - Admin Controls: The admin (insurance provider) has control over the
//   approval or rejection of claims, ensuring fair and regulated decision-making.
//
// Future Scope:
// 1. Integration with Real-World Data: Integration with healthcare providers
//    and medical institutions for direct claim verification.
// 2. Smart Contracts for Payment Execution: Automating payments to claimants
//    once a claim is approved, based on predefined conditions.
// 3. User Interface: Development of a front-end application for easier
//    interaction with the contract.
// 4. Enhanced Claim Verification: Integration of oracles for verifying
//    claim details and medical records.
// 5. Multiple Insurance Providers: The system could be expanded to accommodate
//    multiple insurance providers in a decentralized manner.
// 6. Automated Claim Review: Implement machine learning algorithms for
//    automatic claim review, based on historical claim data.
// 7. Cross-Chain Compatibility: Expanding the system to work across different
//    blockchain platforms, enhancing its scalability and usability.
///////////////////////////////////////////////////////////////

contract MedicalInsuranceClaimManagement {

    // Enum to represent claim status
    enum ClaimStatus { Pending, Approved, Rejected }

    // Structure to hold claim information
    struct Claim {
        uint256 claimId;
        address claimant;
        uint256 amount;
        string description;
        ClaimStatus status;
        uint256 dateSubmitted;
    }

    address public admin; // Admin address to approve/reject claims
    uint256 public claimCount; // To track the number of claims

    mapping(uint256 => Claim) public claims; // Mapping to store claims by ID

    event ClaimSubmitted(uint256 claimId, address claimant, uint256 amount);
    event ClaimStatusUpdated(uint256 claimId, ClaimStatus status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can approve/reject claims.");
        _;
    }

    modifier onlyClaimant(uint256 claimId) {
        require(msg.sender == claims[claimId].claimant, "Only the claimant can modify their claim.");
        _;
    }

    modifier claimExists(uint256 claimId) {
        require(claims[claimId].claimant != address(0), "Claim does not exist.");
        _;
    }

    constructor() {
        admin = msg.sender; // The address deploying the contract is the admin
    }

    // Function to submit a new claim
    function submitClaim(uint256 amount, string memory description) public {
        claimCount++;
        claims[claimCount] = Claim({
            claimId: claimCount,
            claimant: msg.sender,
            amount: amount,
            description: description,
            status: ClaimStatus.Pending,
            dateSubmitted: block.timestamp
        });
        
        emit ClaimSubmitted(claimCount, msg.sender, amount);
    }

    // Function to approve a claim (Only admin can do this)
    function approveClaim(uint256 claimId) public onlyAdmin claimExists(claimId) {
        claims[claimId].status = ClaimStatus.Approved;
        emit ClaimStatusUpdated(claimId, ClaimStatus.Approved);
    }

    // Function to reject a claim (Only admin can do this)
    function rejectClaim(uint256 claimId) public onlyAdmin claimExists(claimId) {
        claims[claimId].status = ClaimStatus.Rejected;
        emit ClaimStatusUpdated(claimId, ClaimStatus.Rejected);
    }

    // Function to get claim details
    function getClaimDetails(uint256 claimId) public view claimExists(claimId) returns (Claim memory) {
        return claims[claimId];
    }

    // Function to get the current claim count
    function getClaimCount() public view returns (uint256) {
        return claimCount;
    }
}

