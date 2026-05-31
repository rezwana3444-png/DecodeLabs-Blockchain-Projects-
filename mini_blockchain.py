import hashlib
import time

class Block:
    def __init__(self, index, data, prev_hash):
        self.index = index
        self.timestamp = time.time()
        self.data = data
        self.prev_hash = prev_hash
        self.nonce = 0
        self.hash = self.mine_block(difficulty=4)

    def calculate_hash(self):
        block_string = f"{self.index}{self.timestamp}{self.data}{self.prev_hash}{self.nonce}"
        return hashlib.sha256(block_string.encode()).hexdigest()

    def mine_block(self, difficulty=4):
        target = "0" * difficulty
        while True:
            self.hash = self.calculate_hash()
            if self.hash.startswith(target):
                print(f"⛏️  Block {self.index} mined! Nonce: {self.nonce} | Hash: {self.hash[:20]}...")
                return self.hash
            self.nonce += 1

class Blockchain:
    def __init__(self):
        self.chain = [self.create_genesis_block()]

    def create_genesis_block(self):
        return Block(0, "Genesis Block", "0")

    def get_latest_block(self):
        return self.chain[-1]

    def add_block(self, data):
        new_block = Block(
            index=len(self.chain),
            data=data,
            prev_hash=self.get_latest_block().hash
        )
        self.chain.append(new_block)

    def validate_chain(self):
        for i in range(1, len(self.chain)):
            current = self.chain[i]
            previous = self.chain[i - 1]
            if current.hash != current.calculate_hash():
                print(f"❌ Block {i} has been tampered!")
                return False
            if current.prev_hash != previous.hash:
                print(f"❌ Block {i} chain link is broken!")
                return False
        print("✅ Blockchain is valid!")
        return True

print("🚀 Creating Blockchain...\n")
my_chain = Blockchain()

print("\n📦 Adding 3 blocks...\n")
my_chain.add_block({"sender": "Alice", "receiver": "Bob", "amount": 50})
my_chain.add_block({"sender": "Bob", "receiver": "Carol", "amount": 25})
my_chain.add_block({"sender": "Carol", "receiver": "Dave", "amount": 10})

print("\n🔍 Checking if chain is valid...")
my_chain.validate_chain()

print("\n😈 Hacker tries to change Block 1 data...")
my_chain.chain[1].data = {"sender": "Alice", "receiver": "HACKER", "amount": 9999}

print("\n🔍 Checking chain again...")
my_chain.validate_chain()