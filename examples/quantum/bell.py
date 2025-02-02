from qiskit.circuit import QuantumCircuit, QuantumRegister, ClassicalRegister
from qiskit.transpiler.preset_passmanagers import generate_preset_pass_manager
from qiskit_ibm_runtime import QiskitRuntimeService, Session, SamplerV2 as Sampler
import numpy as np
import os

# Number of launches
shots = 10

# Connect to IBM Runtime Service
IBMQ_TOKEN = os.getenv('IBMQ_TOKEN')
QiskitRuntimeService.save_account(channel="ibm_quantum", token=IBMQ_TOKEN, overwrite=True)
service = QiskitRuntimeService()

# Choice backend for runtime
backend = service.least_busy(operational=True, simulator=False)

# Make scheme for Bell test
qr = QuantumRegister(2, name="qr")
cr = ClassicalRegister(2, name="cr")
qc = QuantumCircuit(qr, cr, name="bell")

# Make entanglement state |Φ⁺⟩
qc.h(qr[0])
qc.cx(qr[0], qr[1])

qc.measure(qr, cr)

# Apply optimization for scheme
pm = generate_preset_pass_manager(backend=backend, optimization_level=1)
isa_circuit = pm.run(qc)

with Session(backend=backend) as session:
    # Run sampler
    sampler = Sampler(mode=session)
    job = sampler.run([isa_circuit], shots=shots)
    pub_result = job.result()[0]

    # Get results
    counts = pub_result.data.cr.get_counts()
    print(f"Sampler job ID: {job.job_id()}")
    print(f"Counts: {counts}")

    # Calculate correlations for states
    P_00 = counts.get("00", 0)
    P_11 = counts.get("11", 0)
    P_01 = counts.get("01", 0)
    P_10 = counts.get("10", 0)

    correlation = (P_00 + P_11 - P_01 - P_10)
    print(f"Correlation: {correlation}")

    # Calculate Bell S parameter
    S = abs(correlation)
    print(f"Bell S paramenter = {S}")

    # Check Bell inequality
    if S > 2:
        print("Bell's inequality is violated, quantum entanglement detected!")
    else:
        print("Bell's inequality is not violated.")

